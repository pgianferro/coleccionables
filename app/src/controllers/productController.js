const fs = require('fs');
const path = require('path');
const productQueries = require('../database/productQueries');

const rutaDB = path.join(__dirname,'../../public/db/productdb.json');
const readDB = fs.readFileSync(rutaDB,'utf-8');
const dbParseada = JSON.parse(readDB);
const { validationResult } = require('express-validator');
const db = require('../database/models');
const sequelize = db.sequelize;
const { Op } = require("sequelize");


productController={
    showAll: async (req, res) => {
        try {
            //Hago los pedidos a la Base de Datos
            let [products] = await Promise.all([productQueries.showAll]);
            res.render('products/products' , { products , title: 'Productos'});
        } catch (e) {
            //Si hay algun error, los atajo y muestro todo vacio
            console.log('error,' , e);
            res.render('products/products' , { products: [], title: 'Productos'});
        }
    },

    detail: async (req, res) => {
        try{
            let [product] = await Promise.all([productQueries.find(req.params.id)]);

            if(product !== null){
                res.render('products/productDetail' , { product });
            } else {
                res.render('error',{error: 'No existe el producto seleccionado'})
            }
        } catch (e) {
            //Si hay algun error, los atajo y muestro todo vacio
            console.log('error,' , e);
            res.render('products/productDetail' , { products: {} });
        }
    },
    
    create: async (req, res) => {
        let productoVacio = {};
        try{
            //Defino producto vacio segun mi base de datos
            for (let key in dbParseada[0]) productoVacio[key] = "";
            let id = parseInt(req.params.id);
            await Promise.all([db.Category.findAll()]).then(([categories])=>{ //Deberia venir de productQueries pero no andaba
                return res.render('products/productCreate', {producto: productoVacio, categories});
            });
        } catch (e) {
            //Si hay algun error, los atajo y muestro todo vacio
            console.log('error,' , e);
            res.render('products/productCreate' , { producto: productoVacio, title: 'Productos'});
        }
    },
    	// Create -  Method to store
	store: async (req, res) => {
        const resultValidation = validationResult(req);
		
		if (resultValidation.errors.length > 0) {
			return res.render('products/productCreate', {
				errors: resultValidation.mapped(),
				oldData: req.body
			});
		}
        let producto = req.body;
        producto.is_offer=productController.validarOferta(req.body.descuento);
        let urlImagenNueva = '/images/products/default.jpg';
        if (req.file !== undefined){
            urlImagenNueva = '/images/products/' + req.file.filename;
        }
        producto.image_url =urlImagenNueva;
        producto.visits_q = 0;
        producto.sales_q = 0;
        producto.best_seller = 0;


        const [product] = await Promise.all([productQueries.create(producto)]);
		res.redirect("/productos")
	},

    editForm: (req, res) => {
        let id = parseInt(req.params.id);
        let indice = productController.buscarIndiceProductoPorId(id);
        res.render('products/productEdit',{producto: dbParseada[indice], categorias});
    },

    edit: (req,res) => { 
        let idProd = parseInt(req.params.id);
        let indice = productController.buscarIndiceProductoPorId(idProd);
        let visitasProd = parseInt(dbParseada[indice].visitas);
        let vendidosProd = parseInt(dbParseada[indice].vendidos);
        let esMasVendidoProd = dbParseada[indice].esMasVendido;
        let esOferta = productController.validarOferta(req.body.descuento); 
        let esFisico = req.body.esFisico;
        if (req.body.esFisico !== true){esFisico=false}else{esFisico=true};
        request=req.body
        let urlImagenNueva = dbParseada[indice].urlImagen;
        if (req.file !== undefined) urlImagenNueva = '/images/products/' + req.file.filename;
        let productoEditado = { 
            id: idProd,
            sku: req.body.sku,
            titulo: req.body.titulo,
            descripcionCorta: req.body.descripcionCorta,
            descripcionLarga: req.body.descripcionLarga,
            precioRegular: parseInt(req.body.precioRegular),
            descuento: parseInt(req.body.descuento),
            cantidadCuotas: parseInt(req.body.cantidadCuotas),
            etiquetas: req.body.etiquetas,
            esOferta: esOferta,
            esFisico: esFisico,
            categorias: req.body.categories,
            urlImagen: urlImagenNueva,
            visitas: visitasProd,
            vendidos: vendidosProd,
            esMasVendido: esMasVendidoProd
        }
        dbParseada[indice]=productoEditado;
        fs.writeFileSync(rutaDB,JSON.stringify(dbParseada,null,2),"utf-8");
        res.redirect(`/productos/${idProd}`);  
    },

    delete: async (req, res) => {
        try{
            await Promise.all([productQueries.delete(req.params.id)]);
            res.redirect('/productos')
        } catch (e) {
            //Si hay algun error, los atajo y muestro todo vacio
            console.log('error,' , e);
            res.render('error' , { error: e });
        }
    },

    /* METODOS ACCESORIOS*/

    buscarIndiceProductoPorId: id => { //devuelvo indice del producto en productdb
        return dbParseada.findIndex(producto => {
            return producto.id === id;
        });          
    },

    validarOferta: reqBodyDescuento => { //Recibe req.body.descuento, si es mayor a 0 hay oferta.
        if (reqBodyDescuento>0){
            return true
        }else{
            return false
        };
    },

    buscarMaximoId: () => {
        let maximo = 0;
        dbParseada.forEach(producto => {
            if (producto.id > maximo) maximo = producto.id;
        });
        return maximo;
    }
}

module.exports = productController;