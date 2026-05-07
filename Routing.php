<?php

require_once 'src/controllers/SecurityController.php';
require_once 'src/controllers/DashboardController.php';

class Routing {

    public static $routes = [
        "login" => [
            "controller" => "SecurityController",
            "action" => "login"
        ],
        "dashboard" => [
            "controller" => "DashboardController",
            "action" => "index"
        ],
        "" => [
            "controller" => "SecurityController",
            "action" => "login"
        ],
        "register" => [
            "controller" => "SecurityController",
            "action" => "register"
        ],
    ];

    public static $dynamicRoutes = [
        '#^dashboard/(\d+)$#' => [
            "controller" => "DashboardController",
            "action" => "index"
        ],
    ];

    public static function run(string $path) {
        if (array_key_exists($path, Routing::$routes)) {
            $controller = Routing::$routes[$path]["controller"];
            $action = Routing::$routes[$path]["action"];
            $controller::getInstance()->$action(null);
            return;
        }

        foreach (Routing::$dynamicRoutes as $pattern => $route) {
            if (preg_match($pattern, $path, $matches)) {
                $id = $matches[1];
                $controller = $route["controller"];
                $action = $route["action"];
                $controller::getInstance()->$action($id);
                return;
            }
        }

        include 'public/views/404.html';
    }
}