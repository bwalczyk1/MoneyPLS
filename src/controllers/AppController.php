<?php

class AppController {
    protected static ?AppController $instance = null;

    protected function __construct() {}

    protected function isGet(): bool {
        return $_SERVER['REQUEST_METHOD'] === 'GET';
    }

    protected function isPost(): bool {
        return $_SERVER['REQUEST_METHOD'] === 'POST';
    }

    protected function requireAuth(): void {
        if (empty($_SESSION['user_id'])) {
            header('Location: /login');
            exit;
        }
    }

    protected function notFound(): void {
        http_response_code(404);
        include 'public/views/404.html';
    }

    protected function verifyCsrf(): void {
        $token = $_POST['_csrf'] ?? '';
        if (!hash_equals($_SESSION['_csrf'] ?? '', $token)) {
            http_response_code(403);
            die('Invalid CSRF token.');
        }
    }

    protected function redirect(string $path): void {
        header("Location: http://{$_SERVER['HTTP_HOST']}/{$path}");
        exit;
    }

    protected function render(
        string $template,
        array $variables = [],
    ): void {
        $templatePath = 'public/views/' . $template . '.html';

        if (file_exists($templatePath)) {
            extract($variables);
            ob_start();
            include $templatePath;
            echo ob_get_clean();
        } else {
            $this->notFound();
        }
    }
}

function h(mixed $value): string {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function csrf_token(): string {
    if (empty($_SESSION['_csrf'])) {
        $_SESSION['_csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['_csrf'];
}