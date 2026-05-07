<?php
require_once "config.php";

class Database {
    private static ?Database $instance = null;
    private ?PDO $conn = null;

    private function __construct() {}

    public static function getInstance(): Database {
        if (is_null(self::$instance)) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    public function connect(): PDO {
        if ($this->conn === null) {
            try {
                $this->conn = new PDO(
                    "pgsql:host=" . HOST . ";port=5432;dbname=" . DATABASE,
                    USERNAME,
                    PASSWORD,
                    ["sslmode" => "prefer"]
                );
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            } catch (PDOException $e) {
                die("Connection failed: " . $e->getMessage());
            }
        }
        return $this->conn;
    }

    public function disconnect(): void {
        $this->conn = null;
    }
}