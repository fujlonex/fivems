-- ==========================================
--  Tabela logów admina dla adminmenu
-- ==========================================

CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `identifier` VARCHAR(64) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `details` TEXT,
  `time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

