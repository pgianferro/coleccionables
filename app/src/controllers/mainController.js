//CONTROLLERS.
//Seguramente tengamos que dividir en userControllers y productControllers
mainController={
    index: (req, res) => {
        res.render('index');
    },
    
    producto: (req, res) => {
        res.render('productDetail');
    },
    
    carrito: (req, res) => {
        res.render('productCart');
    },
    
    login: (req, res) => {
        res.render('login');
    },

    register: (req, res) => {
        res.render('register');
    },

    create: (req, res) => {
        res.render('productCreate');
    },

    edit: (req, res) => {
        res.render('productEdit');
    }

}

module.exports=mainController;