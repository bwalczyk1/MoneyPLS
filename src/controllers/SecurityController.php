<?php

require_once 'AppController.php';

class SecurityController extends AppController {
    public static function getInstance(): SecurityController {
        if (is_null(self::$instance)) {
            self::$instance = new SecurityController();
        }

        return self::$instance;
    }

    public function login() {
        // TODO sprawdzeie czy user istnieje

        return $this->render("login");
    }
}