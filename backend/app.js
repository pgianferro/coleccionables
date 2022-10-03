require('dotenv').config();
require('./src/middlewares/auth');

//Modulos
const express = require('express');
const app  = express();
const path = require('path');
const methodOverride = require('method-override');
const session = require('express-session');
const authMiddleware = require('./src/middlewares/authMiddleware')
const cors = require('cors');

const passport = require('passport');
const FacebookStrategy = require('passport-facebook').Strategy;

// Routers
const apiRouter = require('./src/routes/apiRouter');
const mainRouter = require('./src/routes/mainRouter');
const productRouter = require('./src/routes/productRouter');
const userRouter = require('./src/routes/userRouter');
const cookieParser = require('cookie-parser');


// MIDDLEWARES
app.use(express.static(__dirname + '/public'));
app.use(methodOverride('_method'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use(session( {secret: process.env.SESSION_SECRET,resave:false,
saveUninitialized: false
}));
app.use(cookieParser());
app.use(authMiddleware);
app.use(cors({origin: '*'}));
app.use(passport.initialize());
app.use(passport.session());


// Inicio Servidor
app.listen(process.env.PORT, () => {
    console.log(`Up & Running en ${process.env.BACKEND_ADDRESS}`);
});

// View Engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname,'/src/views'));


// INICIO DE LAS RUTAS
app.use('/', mainRouter);
app.use('/productos', productRouter);
app.use('/usuarios', userRouter);
app.use('/api', apiRouter);

app.get('/auth', passport.authenticate('google',{scope: ['profile','email']}));
app.get('/auth/success', 
  passport.authenticate('google', { failureRedirect: '/' }),
  function(req, res) {
    let user = req.session.passport.user
    req.session.usuario = user.emails[0].value;
    res.redirect('/');
  });
// SOCIAL LOGIN 
    // FACEBOOK
    /*
passport.use(new FacebookStrategy({
    clientID: process.env.FACEBOOK_ID,
    clientSecret: process.env.FACEBOOK_SECRET,
    callbackURL: "http://localhost:3001/"
  },
  //NO ENTIENDO QUE HACER CON LO DE FACEBOOK ID Y DE DONDE SALE User.findOrCreate
  function(accessToken, refreshToken, profile, cb) {
    User.findOrCreate({ facebookId: profile.id }, function (err, user) {
      return cb(err, user);
    });
  }
));

app.get('/auth/facebook',
  passport.authenticate('facebook'));

app.get('/auth/facebook/callback', passport.authenticate('facebook', { failureRedirect: '/usuarios/inicioSesion' }),
  function(req, res) {
      res.redirect('/');
  });
*/
