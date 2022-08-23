const productQueries = require('../database/productQueries');
const db = require('../database/models');
const sequelize = db.sequelize;
const { Op } = require("sequelize");


mainController = {
    index: async (req, res) => {
        try {
            //Hago los pedidos a la Base de Datos
            const offers = await productQueries.offers();
            const bestSellers = await productQueries.bestSellers();
            
            res.render('index', {
                offers,
                bestSellers,
                usuario: req.session.usuario
            });
        } catch (e) {
            //Si hay algun error, los atajo y muestro todo vacio
            console.log('error,' , e)
            res.render('index', {
                offers: [],
                bestSellers: [],
                usuario: req.session.usuario
            });
        }
    },

    error: (req, res) => {
        res.render('error', { error })
    }

}

module.exports = mainController;