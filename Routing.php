<?php

require_once 'src/controllers/LandingController.php';
require_once 'src/controllers/SecurityController.php';
require_once 'src/controllers/DashboardController.php';
require_once 'src/controllers/GroupsController.php';
require_once 'src/controllers/ExpensesController.php';
require_once 'src/controllers/SettleUpController.php';
require_once 'src/controllers/ActivityController.php';

class Routing {

    public static $routes = [
        "" => [
            "controller" => "LandingController",
            "action" => "index"
        ],
        "login" => [
            "controller" => "SecurityController",
            "action" => "login"
        ],
        "register" => [
            "controller" => "SecurityController",
            "action" => "register"
        ],
        "logout" => [
            "controller" => "SecurityController",
            "action" => "logout"
        ],
        "dashboard" => [
            "controller" => "DashboardController",
            "action" => "index"
        ],
        "groups" => [
            "controller" => "GroupsController",
            "action" => "index"
        ],
        "groups/create" => [
            "controller" => "GroupsController",
            "action" => "create"
        ],
        "activity" => [
            "controller" => "ActivityController",
            "action" => "index"
        ],
    ];

    public static $dynamicRoutes = [
        '#^groups/(\d+)/expenses/add$#' => [
            "controller" => "ExpensesController",
            "action" => "create"
        ],
        '#^groups/(\d+)/settle/pay$#' => [
            "controller" => "SettleUpController",
            "action" => "pay"
        ],
        '#^groups/(\d+)/settle$#' => [
            "controller" => "SettleUpController",
            "action" => "index"
        ],
        '#^groups/(\d+)/balances$#' => [
            "controller" => "GroupsController",
            "action" => "showBalances"
        ],
        '#^groups/(\d+)$#' => [
            "controller" => "GroupsController",
            "action" => "show"
        ],
    ];

    public static function run(string $path): void {
        if (array_key_exists($path, self::$routes)) {
            $route = self::$routes[$path];
            $route['controller']::getInstance()->{$route['action']}(null);
            return;
        }

        foreach (self::$dynamicRoutes as $pattern => $route) {
            if (preg_match($pattern, $path, $matches)) {
                $route['controller']::getInstance()->{$route['action']}($matches[1]);
                return;
            }
        }

        include 'public/views/404.html';
    }
}