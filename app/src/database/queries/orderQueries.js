const db = require('../models');
const sequelize = db.sequelize;
const { Op } = require("sequelize");

module.exports = {
    showAll: async () => await db.Order.findAll({
        include:
        { association: 'status_orders'}
    }),

    find: async (userId) => await db.Order.findOne({
        where: {
            user_id: userId
        },
        include: [
            {
                association: 'status_orders',
                where: {
                    name: 'Pendiente'
                }
            }
        ]
    }),

    create: async (user) => await db.Order.create({
        user_id: user.id,
        shipping_address: user.address,
        billing_address: user.address,
        email: user.email,
        status_id: 1,
        ammount: 0,
        items_q: 0,
        date: Date.now()
    }),
    
    update: async (order) => db.Order.update({
            items_q: order.totalQuantity,
            status_id: 3,  
            ammount: order.ammount
        },
        {
            where: {
                id: order.id
            }
        }
    )
}