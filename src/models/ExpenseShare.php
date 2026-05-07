<?php

require_once __DIR__ . '/AppModel.php';

class ExpenseShare extends AppModel {
    public int $expenseId;
    public int $userId;
    public float $shareAmount;

    public function __construct(int $expenseId = 0, int $userId = 0, float $shareAmount = 0.0) {
        $this->expenseId = $expenseId;
        $this->userId = $userId;
        $this->shareAmount = $shareAmount;
    }

    public function validate(): bool {
        parent::validate();

        if ($this->shareAmount < 0) {
            $this->addError('share_amount', 'Share amount cannot be negative');
        }

        return $this->isValid();
    }

    public static function fromArray(array $data): self {
        return new self(
            $data['expense_id'] ?? 0,
            $data['user_id'] ?? 0,
            (float)($data['share_amount'] ?? 0)
        );
    }
}
