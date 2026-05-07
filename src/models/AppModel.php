<?php

class AppModel {
    protected array $errors = [];

    public function validate(): bool {
        $this->errors = [];
        return true;
    }

    public function getErrors(): array {
        return $this->errors;
    }

    public function isValid(): bool {
        return empty($this->errors);
    }

    protected function addError(string $field, string $message): void {
        $this->errors[$field] = $message;
    }
}
