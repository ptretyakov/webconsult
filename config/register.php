<?php

use Symfony\Component\HttpFoundation\Session\Storage\Handler\PdoSessionHandler;
use \Igorw\Silex\ConfigServiceProvider;
use App\Controllers\ConsultantsController;


# Регистрируем главное приложение
$app 			= new Silex\Application();
$app['debug'] 	= true;

/*
$test 		= new ConsultantsController($app);
$testmes 	= $test->test();
die($testmes);
*/

# Регистрируем шаблонизатор twig
$app->register(new Silex\Provider\TwigServiceProvider(), array(
    'twig.path' => __DIR__.'/../views',
));

# Регистрируем сессию
$app->register(new Silex\Provider\SessionServiceProvider());

$app['twig'] = $app->share($app->extend('twig', function($twig, $app) {
    $twig->addFunction(new \Twig_SimpleFunction('asset', function ($asset) {
        // implement whatever logic you need to determine the asset path
        return sprintf('http://'.$_SERVER['SERVER_NAME'].'/%s', ltrim($asset, '/'));
    }));
    return $twig;
}));

# Регестрируем генератор url-ов
$app->register(new Silex\Provider\UrlGeneratorServiceProvider());

# Регестрируем PDO
$app['pdo.dsn'] = 'mysql:dbname=consult';
$app['pdo.user'] = 'consult';
$app['pdo.password'] = 'consult123';

$app['session.db_options'] = array(
    'db_table'      => 'session',
    'db_id_col'     => 'session_id',
    'db_data_col'   => 'session_value',
    'db_time_col'   => 'session_time',
);

$app['pdo'] = $app->share(function () use ($app) {
    return new PDO(
        $app['pdo.dsn'],
        $app['pdo.user'],
        $app['pdo.password']
    );
});

/**
 * Регестрируем контроллеры
 */
$app->register(new Silex\Provider\ServiceControllerServiceProvider());

# Контроллер консультантов
$app['consultants.controller'] = $app->share(function() use ($app) {
    return new ConsultantsController($app);
});