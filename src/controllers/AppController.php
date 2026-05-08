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

    protected function redirect(string $path): void {
        header("Location: http://{$_SERVER['HTTP_HOST']}/{$path}");
        exit;
    }

    protected function render(string $template, array $variables = []): void {
        $templatePath = 'public/views/' . $template . '.html';

        if (file_exists($templatePath)) {
            extract($variables);
            ob_start();
            include $templatePath;
            echo ob_get_clean();
        } else {
            ob_start();
            include 'public/views/404.html';
            echo ob_get_clean();
        }
    }
}

function h(mixed $value): string {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}