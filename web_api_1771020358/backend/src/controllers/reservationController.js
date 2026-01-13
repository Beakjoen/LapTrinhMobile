const { Reservation, ReservationItem, MenuItem, Table, Customer, sequelize, Sequelize } = require('../../models');
const { Op } = Sequelize;

const generateReservationNumber = async () => {
    const date = new Date();
    const dateStr = date.toISOString().slice(0, 10).replace(/-/g, '');
    const prefix = `RES-${dateStr}-`;

    const lastReservation = await Reservation.findOne({
        where: { reservation_number: { [Op.like]: `${prefix}%` } },
        order: [['id', 'DESC']]
    });

    let sequence = 1;
    if (lastReservation) {
        const parts = lastReservation.reservation_number.split('-');
        if (parts.length === 3) {
            sequence = parseInt(parts[2]) + 1;
        }
    }
    return `${prefix}${sequence.toString().padStart(3, '0')}`;
};

const createReservation = async (req, res, next) => {
    try {
        const { reservation_date, number_of_guests, special_requests } = req.body;
        const reservation_number = await generateReservationNumber();

        const reservation = await Reservation.create({
            customer_id: req.user.id,
            reservation_number,
            reservation_date,
            number_of_guests,
            special_requests,
            status: 'pending'
        });

        res.status(201).json(reservation);
    } catch (error) {
        next(error);
    }
};

const addItemsToReservation = async (req, res, next) => {
    const t = await sequelize.transaction();
    try {
        const { id } = req.params;
        const { menu_item_id, quantity } = req.body;

        const reservation = await Reservation.findByPk(id, { transaction: t });
        if (!reservation) {
            await t.rollback();
            return res.status(404).json({ message: 'Reservation not found' });
        }

        if (req.user.role !== 'admin' && req.user.id !== reservation.customer_id) {
            await t.rollback();
            return res.status(403).json({ message: 'Forbidden' });
        }

        const menuItem = await MenuItem.findByPk(menu_item_id, { transaction: t });
        if (!menuItem || !menuItem.is_available) {
            await t.rollback();
            return res.status(400).json({ message: 'Menu item not available' });
        }

        const price = menuItem.price;
        await ReservationItem.create({
            reservation_id: id,
            menu_item_id,
            quantity,
            price
        }, { transaction: t });

        const items = await ReservationItem.findAll({ where: { reservation_id: id }, transaction: t });
        let subtotal = 0;
        for (const item of items) {
            subtotal += parseFloat(item.price) * item.quantity;
        }

        const service_charge = subtotal * 0.10;
        const total = subtotal + service_charge - reservation.discount;

        await reservation.update({ subtotal, service_charge, total }, { transaction: t });

        await t.commit();
        res.json({ message: 'Item added', reservation: await Reservation.findByPk(id, { include: ['items'] }) });
    } catch (error) {
        await t.rollback();
        next(error);
    }
};

const confirmReservation = async (req, res, next) => {
    const t = await sequelize.transaction();
    try {
        const { id } = req.params;
        const { table_number } = req.body;

        const reservation = await Reservation.findByPk(id, { transaction: t });
        if (!reservation) {
            await t.rollback();
            return res.status(404).json({ message: 'Reservation not found' });
        }

        const table = await Table.findOne({ where: { table_number }, transaction: t });
        if (!table) {
            await t.rollback();
            return res.status(404).json({ message: 'Table not found' });
        }

        if (!table.is_available) {
            await t.rollback();
            return res.status(400).json({ message: 'Table is not available' });
        }

        if (table.capacity < reservation.number_of_guests) {
            await t.rollback();
            return res.status(400).json({ message: 'Table capacity insufficient' });
        }

        await reservation.update({ status: 'confirmed', table_number }, { transaction: t });
        await table.update({ is_available: false }, { transaction: t });

        await t.commit();
        res.json({ message: 'Reservation confirmed', reservation });
    } catch (error) {
        await t.rollback();
        next(error);
    }
};

const getReservationById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const reservation = await Reservation.findByPk(id, {
            include: [{
                model: ReservationItem,
                as: 'items',
                include: [{ model: MenuItem, as: 'menu_item' }]
            }]
        });

        if (!reservation) return res.status(404).json({ message: 'Reservation not found' });

        if (req.user.role !== 'admin' && req.user.id !== reservation.customer_id) {
            return res.status(403).json({ message: 'Forbidden' });
        }

        res.json(reservation);
    } catch (error) {
        next(error);
    }
};

const payReservation = async (req, res, next) => {
    const t = await sequelize.transaction();
    try {
        const { id } = req.params;
        const { payment_method, use_loyalty_points, loyalty_points_to_use } = req.body;

        const reservation = await Reservation.findByPk(id, { transaction: t });
        if (!reservation) {
            await t.rollback();
            return res.status(404).json({ message: 'Reservation not found' });
        }

        if (!['seated', 'confirmed'].includes(reservation.status)) {
            await t.rollback();
            return res.status(400).json({ message: 'Reservation must be seated or confirmed to pay' });
        }

        const customer = await Customer.findByPk(reservation.customer_id, { transaction: t });

        let discount = 0;
        let finalTotal = parseFloat(reservation.total);

        if (use_loyalty_points && loyalty_points_to_use > 0) {
            if (customer.loyalty_points < loyalty_points_to_use) {
                await t.rollback();
                return res.status(400).json({ message: 'Insufficient loyalty points' });
            }

            const maxDiscount = finalTotal * 0.5;
            let discountAmount = loyalty_points_to_use * 1000;

            if (discountAmount > maxDiscount) {
                discountAmount = maxDiscount;
            }

            discount = discountAmount;
            finalTotal = finalTotal - discount;

            await customer.decrement('loyalty_points', { by: loyalty_points_to_use, transaction: t });
        }

        await reservation.update({
            discount,
            total: finalTotal,
            payment_method,
            payment_status: 'paid',
            status: 'completed'
        }, { transaction: t });

        await customer.increment('loyalty_points', { by: Math.floor(finalTotal / 100), transaction: t });

        if (reservation.table_number) {
            const table = await Table.findOne({ where: { table_number: reservation.table_number }, transaction: t });
            if (table) {
                await table.update({ is_available: true }, { transaction: t });
            }
        }

        await t.commit();
        res.json({ message: 'Payment successful', reservation, pointsEarned: Math.floor(finalTotal / 100) });
    } catch (error) {
        await t.rollback();
        next(error);
    }
};

const cancelReservation = async (req, res, next) => {
    const t = await sequelize.transaction();
    try {
        const { id } = req.params;
        const reservation = await Reservation.findByPk(id, { transaction: t });
        if (!reservation) {
            await t.rollback();
            return res.status(404).json({ message: 'Reservation not found' });
        }

        if (req.user.role !== 'admin') {
            if (req.user.id !== reservation.customer_id) {
                await t.rollback();
                return res.status(403).json({ message: 'Forbidden' });
            }
            if (!['pending', 'confirmed'].includes(reservation.status)) {
                await t.rollback();
                return res.status(400).json({ message: 'Cannot cancel reservation in this status' });
            }
        }

        await reservation.update({ status: 'cancelled' }, { transaction: t });

        if (reservation.table_number) {
            const table = await Table.findOne({ where: { table_number: reservation.table_number }, transaction: t });
            if (table) {
                await table.update({ is_available: true }, { transaction: t });
            }
        }

        await t.commit();
        res.json({ message: 'Reservation cancelled' });
    } catch (error) {
        await t.rollback();
        next(error);
    }
};

module.exports = {
    createReservation,
    addItemsToReservation,
    confirmReservation,
    getReservationById,
    payReservation,
    cancelReservation
};
