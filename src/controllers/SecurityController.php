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
            http_response_code(400);
            return $this->render('auth', ['mode' => 'login', 'error' => 'Fill all fields']);
        }

        $repo = new UsersRepository();
        $user = $repo->getUserByEmail($email);

        if (!$user || !password_verify($password, $user->password)) {
            http_response_code(401);

            return $this->render(
                'auth',
                ['mode' => 'login', 'error' => 'Invalid email or password'],
            );
        }

        session_regenerate_id(true);
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

        $error = match(true) {
            empty($email) || empty($password) || empty($username) || empty($fullName) => 'Fill all fields',
            $password !== $password2 => 'Passwords do not match',
            strlen($password) < 8 => 'Password must be at least 8 characters',
            default => '',
        }

        if (!empty($error)) {
            http_response_code(400);

            return $this->render('auth', [
                'mode' => 'register',
                'error' => $error,
                'old' => $_POST,
            ]);
        }

        $repo = new UsersRepository();

        if ($repo->getUserByEmail($email)) {
            http_response_code(400);

            return $this->render('auth', [
                'mode' => 'register',
                'error' => 'Email already in use',
                'old' => $_POST,
            ]);
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