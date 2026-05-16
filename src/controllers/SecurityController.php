<?php

require_once 'AppController.php';
require_once __DIR__.'/../repositories/UsersRepository.php';

class SecurityController extends AppController {
    protected static ?AppController $instance = null;

    public static function getInstance(): SecurityController {
        if (is_null(self::$instance)) {
            self::$instance = new SecurityController();
        }

        return self::$instance;
    }

    public function login() {
        if (!$this->isPost()) {
            return $this->render('auth', ['mode' => 'login']);
        }

        $email    = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';

        if (empty($email) || empty($password)) {
            return $this->render('auth', ['mode' => 'login', 'error' => 'Fill all fields']);
        }

        $repo = new UsersRepository();
        $user = $repo->getUserByEmail($email);

        if (!$user || !password_verify($password, $user->password)) {
            return $this->render('auth', ['mode' => 'login', 'error' => 'Invalid email or password']);
        }

        $_SESSION['user_id']  = $user->id;
        $_SESSION['username'] = $user->username;

        $this->redirect('dashboard');
    }

    public function register() {
        if (!$this->isPost()) {
            return $this->render('auth', ['mode' => 'register']);
        }

        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $password2 = $_POST['password2'] ?? '';
        $username = trim($_POST['username'] ?? '');
        $fullName = trim($_POST['full_name'] ?? '');

        if (empty($email) || empty($password) || empty($username) || empty($fullName)) {
            return $this->render('auth', ['mode' => 'register', 'error' => 'Fill all fields', 'old' => $_POST]);
        }

        if ($password !== $password2) {
            return $this->render('auth', ['mode' => 'register', 'error' => 'Passwords do not match', 'old' => $_POST]);
        }

        if (strlen($password) < 8) {
            return $this->render('auth', ['mode' => 'register', 'error' => 'Password must be at least 8 characters', 'old' => $_POST]);
        }

        $repo = new UsersRepository();
        if ($repo->getUserByEmail($email)) {
            return $this->render('auth', ['mode' => 'register', 'error' => 'Email already in use', 'old' => $_POST]);
        }

        $repo->createUser($email, password_hash($password, PASSWORD_BCRYPT), $username, $fullName);

        $this->redirect('login');
    }

    public function logout() {
        $_SESSION = [];
        session_destroy();
        $this->redirect('login');
    }
}