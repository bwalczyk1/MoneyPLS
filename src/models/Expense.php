<?php

require_once __DIR__ . '/AppModel.php';

class Expense extends AppModel {
    public ?int $id;
    public int $groupId;
    public int $paidBy;
    public string $description;
    public string $category;
    public float $amount;
    public string $expenseDate;
    public ?string $createdAt;

    private const CATEGORIES = ['general', 'food', 'transport', 'accommodation', 'entertainment', 'other'];

    public function __construct(
        int $groupId = 0,
        int $paidBy = 0,
        string $description = '',
        string $category = 'general',
        float $amount = 0.0,
        string $expenseDate = '',
        ?int $id = null,
        ?string $createdAt = null
    ) {
        $this->id = $id;
        $this->groupId = $groupId;
        $this->paidBy = $paidBy;
        $this->description = $description;
        $this->category = $category;
        $this->amount = $amount;
        $this->expenseDate = $expenseDate ?: date('Y-m-d');
        $this->createdAt = $createdAt;
    }

    public function validate(): bool {
        parent::validate();

        if (empty($this->description)) {
            $this->addError('description', 'Description is required');
        } elseif (strlen($this->description) > 200) {
            $this->addError('description', 'Description cannot exceed 200 characters');
        }

        if ($this->amount <= 0) {
            $this->addError('amount', 'Amount must be greater than 0');
        }

        if (!in_array($this->category, self::CATEGORIES)) {
            $this->addError('category', 'Invalid category');
        }

        if (!$this->expenseDate || !strtotime($this->expenseDate)) {
            $this->addError('expense_date', 'Invalid date');
        }

        return $this->isValid();
    }

    public static function fromArray(array $data): self {
        return new self(
            $data['group_id'] ?? 0,
            $data['paid_by'] ?? 0,
            $data['description'] ?? '',
            $data['category'] ?? 'general',
            (float)($data['amount'] ?? 0),
            $data['expense_date'] ?? date('Y-m-d'),
            $data['id'] ?? null,
            $data['created_at'] ?? null
        );
    }

    public static function categories(): array {
        return self::CATEGORIES;
    }
}
