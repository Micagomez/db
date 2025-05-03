-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Tiempo de generación: 02-05-2025 a las 23:04:47
-- Versión del servidor: 5.7.44
-- Versión de PHP: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cooperative_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activities`
--

CREATE TABLE `activities` (
  `id_activity` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `id_institution` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `activities`
--
DELIMITER $$
CREATE TRIGGER `after_activity_insert` AFTER INSERT ON `activities` FOR EACH ROW BEGIN
    INSERT INTO activities_audit (id_activity, name, description, id_institution, status, operation)
    VALUES (NEW.id_activity, NEW.name, NEW.description, NEW.id_institution, NEW.status, 'INSERT');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_activity_update` AFTER UPDATE ON `activities` FOR EACH ROW BEGIN
    INSERT INTO activities_audit (id_activity, name, description, id_institution, status, operation)
    VALUES (NEW.id_activity, NEW.name, NEW.description, NEW.id_institution, NEW.status, 'UPDATE');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activities_audit`
--

CREATE TABLE `activities_audit` (
  `id_activity` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `id_institution` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active',
  `operation` enum('INSERT','UPDATE') NOT NULL,
  `operation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `annex`
--

CREATE TABLE `annex` (
  `id_annex` int(11) NOT NULL,
  `id_institution` int(11) NOT NULL,
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `annex`
--
DELIMITER $$
CREATE TRIGGER `trg_annex_insert` AFTER INSERT ON `annex` FOR EACH ROW BEGIN
    INSERT INTO annex_audit (
        id_annex,
        id_institution,
        street,
        number,
        status,
        action_type,
        changed_at
    ) VALUES (
        NEW.id_annex,
        NEW.id_institution,
        NEW.street,
        NEW.number,
        NEW.status,
        'INSERT',
        NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_annex_update` AFTER UPDATE ON `annex` FOR EACH ROW BEGIN
    INSERT INTO annex_audit (
        id_annex,
        id_institution,
        street,
        number,
        status,
        action_type,
        changed_at
    ) VALUES (
        NEW.id_annex,
        NEW.id_institution,
        NEW.street,
        NEW.number,
        NEW.status,
        'UPDATE',
        NOW()
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `annex_audit`
--

CREATE TABLE `annex_audit` (
  `id_annex` int(11) DEFAULT NULL,
  `id_institution` int(11) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contact_type`
--

CREATE TABLE `contact_type` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0.-deleted, 1.-active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contact_type`
--

INSERT INTO `contact_type` (`id`, `type`, `status`) VALUES
(1, 'email', 1),
(2, 'celular', 1),
(3, 'teléfono fijo', 1);

--
-- Disparadores `contact_type`
--
DELIMITER $$
CREATE TRIGGER `after_contact_type_insert` AFTER INSERT ON `contact_type` FOR EACH ROW BEGIN
    INSERT INTO contact_type_audit (
        id, type, status, action_type
    )
    VALUES (
        NEW.id, NEW.type, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_contact_type_update` AFTER UPDATE ON `contact_type` FOR EACH ROW BEGIN
    INSERT INTO contact_type_audit (
        id, type, status, action_type
    )
    VALUES (
        NEW.id, NEW.type, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contact_type_audit`
--

CREATE TABLE `contact_type_audit` (
  `audit_id` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id` int(10) UNSIGNED DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `action_timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `installments`
--

CREATE TABLE `installments` (
  `id_installment` int(11) NOT NULL,
  `id_subscriptions` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `id_payment_method` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `installments`
--
DELIMITER $$
CREATE TRIGGER `after_installment_insert` AFTER INSERT ON `installments` FOR EACH ROW BEGIN
    INSERT INTO installments_audit (
        id_installment, id_subscriptions, amount, payment_date, expiry_date,
        id_payment_method, status, operation
    ) VALUES (
        NEW.id_installment, NEW.id_subscriptions, NEW.amount, NEW.payment_date,
        NEW.expiry_date, NEW.id_payment_method, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_installment_update` AFTER UPDATE ON `installments` FOR EACH ROW BEGIN
    INSERT INTO installments_audit (
        id_installment, id_subscriptions, amount, payment_date, expiry_date, id_payment_method, status, operation
    ) VALUES (
        NEW.id_installment, NEW.id_subscriptions, NEW.amount, NEW.payment_date, NEW.expiry_date, NEW.id_payment_method, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `installments_audit`
--

CREATE TABLE `installments_audit` (
  `id_audit` int(11) NOT NULL,
  `id_installment` int(11) NOT NULL,
  `id_subscriptions` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `id_payment_method` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `operation` varchar(10) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institutions`
--

CREATE TABLE `institutions` (
  `id_institution` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `entity_code` varchar(20) NOT NULL,
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `floor` varchar(10) DEFAULT NULL,
  `apartment` varchar(10) DEFAULT NULL,
  `creation_date` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `institutions`
--
DELIMITER $$
CREATE TRIGGER `after_institution_insert` AFTER INSERT ON `institutions` FOR EACH ROW BEGIN
    INSERT INTO institutions_audit (
        id_institution, name, entity_code, street, number, postal_code,
        floor, apartment, creation_date, status, operation_type
    ) VALUES (
        NEW.id_institution, NEW.name, NEW.entity_code, NEW.street, NEW.number,
        NEW.postal_code, NEW.floor, NEW.apartment, NEW.creation_date, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_institution_update` AFTER UPDATE ON `institutions` FOR EACH ROW BEGIN
    INSERT INTO institutions_audit (
        id_institution, name, entity_code, street, number, postal_code,
        floor, apartment, creation_date, status, operation_type
    ) VALUES (
        NEW.id_institution, NEW.name, NEW.entity_code, NEW.street, NEW.number,
        NEW.postal_code, NEW.floor, NEW.apartment, NEW.creation_date, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institutions_audit`
--

CREATE TABLE `institutions_audit` (
  `audit_id` int(11) NOT NULL,
  `operation_type` varchar(10) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_institution` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `entity_code` varchar(20) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `floor` varchar(10) DEFAULT NULL,
  `apartment` varchar(10) DEFAULT NULL,
  `creation_date` date DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id_payment_method` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `payment_methods`
--

INSERT INTO `payment_methods` (`id_payment_method`, `name`, `status`) VALUES
(1, 'efectivo', 1),
(2, 'tarjeta', 1),
(3, 'transferencia', 1);

--
-- Disparadores `payment_methods`
--
DELIMITER $$
CREATE TRIGGER `after_payment_methods_insert` AFTER INSERT ON `payment_methods` FOR EACH ROW BEGIN
    INSERT INTO payment_methods_audit (
        id_payment_method, name, status, operation
    )
    VALUES (
        NEW.id_payment_method, NEW.name, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_payment_methods_update` AFTER UPDATE ON `payment_methods` FOR EACH ROW BEGIN
    INSERT INTO payment_methods_audit (
        id_payment_method, name, status, operation
    )
    VALUES (
        NEW.id_payment_method, NEW.name, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `payment_methods_audit`
--

CREATE TABLE `payment_methods_audit` (
  `id_audit` int(11) NOT NULL,
  `id_payment_method` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `operation` enum('INSERT','UPDATE') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `people`
--

CREATE TABLE `people` (
  `id_person` int(11) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `id_contact_type` int(10) UNSIGNED DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active',
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `people`
--
DELIMITER $$
CREATE TRIGGER `after_people_insert` AFTER INSERT ON `people` FOR EACH ROW BEGIN
    INSERT INTO people_audit (
        operation, id_person, dni, first_name, last_name, 
        id_contact_type, postal_code, status, street, number, change_date
    )
    VALUES (
        'INSERT', NEW.id_person, NEW.dni, NEW.first_name, NEW.last_name, 
        NEW.id_contact_type, NEW.postal_code, NEW.status, NEW.street, NEW.number, NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_people_update` AFTER UPDATE ON `people` FOR EACH ROW BEGIN
    INSERT INTO people_audit (
        operation, id_person, dni, first_name, last_name, 
        id_contact_type, postal_code, status, street, number, change_date
    )
    VALUES (
        'UPDATE', NEW.id_person, NEW.dni, NEW.first_name, NEW.last_name, 
        NEW.id_contact_type, NEW.postal_code, NEW.status, NEW.street, NEW.number, NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `people_update_audit` AFTER UPDATE ON `people` FOR EACH ROW BEGIN
    INSERT INTO people_auditoria (action_type, id_person, dni, first_name, last_name, id_contact_type, postal_code, status)
    VALUES ('UPDATE', OLD.id_person, OLD.dni, OLD.first_name, OLD.last_name, OLD.id_contact_type, OLD.postal_code, OLD.status);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `people_audit`
--

CREATE TABLE `people_audit` (
  `audit_id` int(11) NOT NULL,
  `operation` varchar(10) NOT NULL,
  `id_person` int(11) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `id_contact_type` int(11) NOT NULL,
  `postal_code` varchar(10) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `street` varchar(100) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `change_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `receipts`
--

CREATE TABLE `receipts` (
  `id_receipt` int(11) NOT NULL,
  `receipt_number` varchar(50) NOT NULL,
  `id_institution` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `receipts`
--
DELIMITER $$
CREATE TRIGGER `after_receipt_insert` AFTER INSERT ON `receipts` FOR EACH ROW BEGIN
    INSERT INTO receipts_audit (
        id_receipt, receipt_number, id_institution, status, action_type
    )
    VALUES (
        NEW.id_receipt, NEW.receipt_number, NEW.id_institution, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_receipt_update` AFTER UPDATE ON `receipts` FOR EACH ROW BEGIN
    INSERT INTO receipts_audit (
        id_receipt, receipt_number, id_institution, status, action_type
    )
    VALUES (
        NEW.id_receipt, NEW.receipt_number, NEW.id_institution, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `receipts_audit`
--

CREATE TABLE `receipts_audit` (
  `audit_id` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id_receipt` int(11) DEFAULT NULL,
  `receipt_number` varchar(50) DEFAULT NULL,
  `id_institution` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `action_timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `receipt_details`
--

CREATE TABLE `receipt_details` (
  `id_receipt_detail` int(11) NOT NULL,
  `id_receipt` int(11) NOT NULL,
  `id_installment` int(11) NOT NULL,
  `issue_date` date NOT NULL,
  `id_user` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `receipt_details`
--
DELIMITER $$
CREATE TRIGGER `after_receipt_details_insert` AFTER INSERT ON `receipt_details` FOR EACH ROW BEGIN
    INSERT INTO receipt_details_audit (
        id_receipt_detail, id_receipt, id_installment,
        issue_date, id_user, status, action_type, changed_at
    )
    VALUES (
        NEW.id_receipt_detail, NEW.id_receipt, NEW.id_installment,
        NEW.issue_date, NEW.id_user, NEW.status, 'INSERT', NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_receipt_details_update` AFTER UPDATE ON `receipt_details` FOR EACH ROW BEGIN
    INSERT INTO receipt_details_audit (
        id_receipt_detail, id_receipt, id_installment,
        issue_date, id_user, status, action_type, changed_at
    )
    VALUES (
        NEW.id_receipt_detail, NEW.id_receipt, NEW.id_installment,
        NEW.issue_date, NEW.id_user, NEW.status, 'UPDATE', NOW()
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `receipt_details_audit`
--

CREATE TABLE `receipt_details_audit` (
  `id_audit` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id_receipt_detail` int(11) DEFAULT NULL,
  `id_receipt` int(11) DEFAULT NULL,
  `id_installment` int(11) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(10) UNSIGNED NOT NULL,
  `rol_type` varchar(100) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `rol_type`, `status`) VALUES
(1, 'rol de root', 1),
(2, 'rol de administrador institucion', 1),
(3, 'rol de preceptor institucion', 1);

--
-- Disparadores `roles`
--
DELIMITER $$
CREATE TRIGGER `after_roles_insert` AFTER INSERT ON `roles` FOR EACH ROW BEGIN
    INSERT INTO roles_audit (
        id_rol, rol_type, status, action_type
    )
    VALUES (
        NEW.id_rol, NEW.rol_type, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_roles_update` AFTER UPDATE ON `roles` FOR EACH ROW BEGIN
    INSERT INTO roles_audit (
        id_rol, rol_type, status, action_type
    )
    VALUES (
        NEW.id_rol, NEW.rol_type, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_audit`
--

CREATE TABLE `roles_audit` (
  `id_audit` int(11) NOT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `id_rol` int(11) NOT NULL,
  `rol_type` varchar(100) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `changed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `scheduled_activities`
--

CREATE TABLE `scheduled_activities` (
  `id_scheduled_activity` int(11) NOT NULL,
  `id_activity` int(11) NOT NULL,
  `id_shift` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `scheduled_activities`
--
DELIMITER $$
CREATE TRIGGER `after_scheduled_activities_insert` AFTER INSERT ON `scheduled_activities` FOR EACH ROW BEGIN
    INSERT INTO scheduled_activities_audit (
        id_scheduled_activity, id_activity, id_shift, start_date,
        end_date, value, status, action_type
    )
    VALUES (
        NEW.id_scheduled_activity, NEW.id_activity, NEW.id_shift, NEW.start_date,
        NEW.end_date, NEW.value, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_scheduled_activities_update` AFTER UPDATE ON `scheduled_activities` FOR EACH ROW BEGIN
    INSERT INTO scheduled_activities_audit (
        id_scheduled_activity, id_activity, id_shift, start_date,
        end_date, value, status, action_type
    )
    VALUES (
        NEW.id_scheduled_activity, NEW.id_activity, NEW.id_shift, NEW.start_date,
        NEW.end_date, NEW.value, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `scheduled_activities_audit`
--

CREATE TABLE `scheduled_activities_audit` (
  `id_audit` int(11) NOT NULL,
  `id_scheduled_activity` int(11) DEFAULT NULL,
  `id_activity` int(11) DEFAULT NULL,
  `id_shift` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `value` decimal(10,2) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `operation` varchar(10) DEFAULT NULL,
  `operation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shifts`
--

CREATE TABLE `shifts` (
  `id_shift` int(11) NOT NULL,
  `detail` varchar(50) NOT NULL,
  `id_institution` int(11) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `shifts`
--

INSERT INTO `shifts` (`id_shift`, `detail`, `id_institution`, `status`) VALUES
(1, 'turno mañana', NULL, 1),
(2, 'turno tarde', NULL, 1),
(3, 'turno vespertino', NULL, 1);

--
-- Disparadores `shifts`
--
DELIMITER $$
CREATE TRIGGER `after_shifts_insert` AFTER INSERT ON `shifts` FOR EACH ROW BEGIN
    INSERT INTO shifts_audit (
        id_shift, detail, id_institution, status, action_type
    )
    VALUES (
        NEW.id_shift, NEW.detail, NEW.id_institution, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_shifts_update` AFTER UPDATE ON `shifts` FOR EACH ROW BEGIN
    INSERT INTO shifts_audit (
        id_shift, detail, id_institution, status, action_type
    )
    VALUES (
        NEW.id_shift, NEW.detail, NEW.id_institution, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `shifts_audit`
--

CREATE TABLE `shifts_audit` (
  `audit_id` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id_shift` int(11) DEFAULT NULL,
  `detail` varchar(50) DEFAULT NULL,
  `id_institution` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `action_timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id_subscriptions` int(11) NOT NULL,
  `id_scheduled_activity` int(11) NOT NULL,
  `id_person` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `subscriptions`
--
DELIMITER $$
CREATE TRIGGER `after_subscriptions_insert` AFTER INSERT ON `subscriptions` FOR EACH ROW BEGIN
    INSERT INTO subscriptions_audit (
        id_subscriptions, id_scheduled_activity, id_person, status, action_type
    )
    VALUES (
        NEW.id_subscriptions, NEW.id_scheduled_activity, NEW.id_person, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_subscriptions_update` AFTER UPDATE ON `subscriptions` FOR EACH ROW BEGIN
    INSERT INTO subscriptions_audit (
        id_subscriptions, id_scheduled_activity, id_person, status, action_type
    )
    VALUES (
        NEW.id_subscriptions, NEW.id_scheduled_activity, NEW.id_person, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subscriptions_audit`
--

CREATE TABLE `subscriptions_audit` (
  `id_audit` int(11) NOT NULL,
  `id_subscriptions` int(11) DEFAULT NULL,
  `id_scheduled_activity` int(11) DEFAULT NULL,
  `id_person` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `operation` varchar(10) DEFAULT NULL,
  `audit_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` date DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `users`
--
DELIMITER $$
CREATE TRIGGER `after_user_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO users_audit (id_user, email, password, creation_date, status, action_type)
    VALUES (NEW.id_user, NEW.email, NEW.password, NEW.creation_date, NEW.status, 'INSERT');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_user_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    INSERT INTO users_audit (id_user, email, password, creation_date, status, action_type)
    VALUES (NEW.id_user, NEW.email, NEW.password, NEW.creation_date, NEW.status, 'UPDATE');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_users` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO users_audit (action_type, id_user, email, password, creation_date, status)
    VALUES ('INSERT', NEW.id_user, NEW.email, NEW.password, NEW.creation_date, NEW.status);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_users` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    INSERT INTO users_audit (action_type, id_user, email, password, creation_date, status)
    VALUES ('UPDATE', OLD.id_user, OLD.email, OLD.password, OLD.creation_date, OLD.status);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_audit`
--

CREATE TABLE `users_audit` (
  `audit_id` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `action_timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_institutions`
--

CREATE TABLE `user_institutions` (
  `id_user_institutions` int(11) NOT NULL,
  `id_institution` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_rol` int(10) UNSIGNED NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0.- deleted; 1.- active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `user_institutions`
--
DELIMITER $$
CREATE TRIGGER `after_user_institutions_insert` AFTER INSERT ON `user_institutions` FOR EACH ROW BEGIN
    INSERT INTO user_institutions_audit (
        id_user_institutions, id_institution, id_user, id_rol, status, action_type
    )
    VALUES (
        NEW.id_user_institutions, NEW.id_institution, NEW.id_user, NEW.id_rol, NEW.status, 'INSERT'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_user_institutions_update` AFTER UPDATE ON `user_institutions` FOR EACH ROW BEGIN
    INSERT INTO user_institutions_audit (
        id_user_institutions, id_institution, id_user, id_rol, status, action_type
    )
    VALUES (
        NEW.id_user_institutions, NEW.id_institution, NEW.id_user, NEW.id_rol, NEW.status, 'UPDATE'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_institutions_audit`
--

CREATE TABLE `user_institutions_audit` (
  `audit_id` int(11) NOT NULL,
  `action_type` varchar(10) DEFAULT NULL,
  `id_user_institutions` int(11) DEFAULT NULL,
  `id_institution` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `id_rol` int(10) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `action_timestamp` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id_activity`),
  ADD KEY `id_institution` (`id_institution`);

--
-- Indices de la tabla `annex`
--
ALTER TABLE `annex`
  ADD PRIMARY KEY (`id_annex`);

--
-- Indices de la tabla `contact_type`
--
ALTER TABLE `contact_type`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contact_type_audit`
--
ALTER TABLE `contact_type_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `installments`
--
ALTER TABLE `installments`
  ADD PRIMARY KEY (`id_installment`),
  ADD KEY `id_subscriptions` (`id_subscriptions`),
  ADD KEY `id_payment_method` (`id_payment_method`);

--
-- Indices de la tabla `installments_audit`
--
ALTER TABLE `installments_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `institutions`
--
ALTER TABLE `institutions`
  ADD PRIMARY KEY (`id_institution`);

--
-- Indices de la tabla `institutions_audit`
--
ALTER TABLE `institutions_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id_payment_method`);

--
-- Indices de la tabla `payment_methods_audit`
--
ALTER TABLE `payment_methods_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`id_person`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `id_contact_type` (`id_contact_type`);

--
-- Indices de la tabla `people_audit`
--
ALTER TABLE `people_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id_receipt`),
  ADD KEY `id_institution` (`id_institution`);

--
-- Indices de la tabla `receipts_audit`
--
ALTER TABLE `receipts_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `receipt_details`
--
ALTER TABLE `receipt_details`
  ADD PRIMARY KEY (`id_receipt_detail`),
  ADD KEY `id_receipt` (`id_receipt`),
  ADD KEY `id_installment` (`id_installment`),
  ADD KEY `id_user` (`id_user`);

--
-- Indices de la tabla `receipt_details_audit`
--
ALTER TABLE `receipt_details_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `roles_audit`
--
ALTER TABLE `roles_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `scheduled_activities`
--
ALTER TABLE `scheduled_activities`
  ADD PRIMARY KEY (`id_scheduled_activity`),
  ADD KEY `id_activity` (`id_activity`),
  ADD KEY `id_shift` (`id_shift`);

--
-- Indices de la tabla `scheduled_activities_audit`
--
ALTER TABLE `scheduled_activities_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id_shift`),
  ADD KEY `id_institution` (`id_institution`);

--
-- Indices de la tabla `shifts_audit`
--
ALTER TABLE `shifts_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id_subscriptions`),
  ADD KEY `id_scheduled_activity` (`id_scheduled_activity`),
  ADD KEY `id_person` (`id_person`);

--
-- Indices de la tabla `subscriptions_audit`
--
ALTER TABLE `subscriptions_audit`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `users_audit`
--
ALTER TABLE `users_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indices de la tabla `user_institutions`
--
ALTER TABLE `user_institutions`
  ADD PRIMARY KEY (`id_user_institutions`),
  ADD KEY `id_institution` (`id_institution`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `user_institutions_audit`
--
ALTER TABLE `user_institutions_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `activities`
--
ALTER TABLE `activities`
  MODIFY `id_activity` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `annex`
--
ALTER TABLE `annex`
  MODIFY `id_annex` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contact_type_audit`
--
ALTER TABLE `contact_type_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `installments`
--
ALTER TABLE `installments`
  MODIFY `id_installment` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `installments_audit`
--
ALTER TABLE `installments_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `institutions`
--
ALTER TABLE `institutions`
  MODIFY `id_institution` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `institutions_audit`
--
ALTER TABLE `institutions_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id_payment_method` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `payment_methods_audit`
--
ALTER TABLE `payment_methods_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `people`
--
ALTER TABLE `people`
  MODIFY `id_person` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `people_audit`
--
ALTER TABLE `people_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `receipts`
--
ALTER TABLE `receipts`
  MODIFY `id_receipt` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `receipts_audit`
--
ALTER TABLE `receipts_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `receipt_details`
--
ALTER TABLE `receipt_details`
  MODIFY `id_receipt_detail` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `receipt_details_audit`
--
ALTER TABLE `receipt_details_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `roles_audit`
--
ALTER TABLE `roles_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `scheduled_activities`
--
ALTER TABLE `scheduled_activities`
  MODIFY `id_scheduled_activity` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `scheduled_activities_audit`
--
ALTER TABLE `scheduled_activities_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id_shift` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `shifts_audit`
--
ALTER TABLE `shifts_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id_subscriptions` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subscriptions_audit`
--
ALTER TABLE `subscriptions_audit`
  MODIFY `id_audit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users_audit`
--
ALTER TABLE `users_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user_institutions`
--
ALTER TABLE `user_institutions`
  MODIFY `id_user_institutions` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `user_institutions_audit`
--
ALTER TABLE `user_institutions_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`id_institution`) REFERENCES `institutions` (`id_institution`);

--
-- Filtros para la tabla `installments`
--
ALTER TABLE `installments`
  ADD CONSTRAINT `installments_ibfk_1` FOREIGN KEY (`id_subscriptions`) REFERENCES `subscriptions` (`id_subscriptions`),
  ADD CONSTRAINT `installments_ibfk_2` FOREIGN KEY (`id_payment_method`) REFERENCES `payment_methods` (`id_payment_method`);

--
-- Filtros para la tabla `people`
--
ALTER TABLE `people`
  ADD CONSTRAINT `people_ibfk_1` FOREIGN KEY (`id_contact_type`) REFERENCES `contact_type` (`id`);

--
-- Filtros para la tabla `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `receipts_ibfk_1` FOREIGN KEY (`id_institution`) REFERENCES `institutions` (`id_institution`);

--
-- Filtros para la tabla `receipt_details`
--
ALTER TABLE `receipt_details`
  ADD CONSTRAINT `receipt_details_ibfk_1` FOREIGN KEY (`id_receipt`) REFERENCES `receipts` (`id_receipt`),
  ADD CONSTRAINT `receipt_details_ibfk_2` FOREIGN KEY (`id_installment`) REFERENCES `installments` (`id_installment`),
  ADD CONSTRAINT `receipt_details_ibfk_3` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Filtros para la tabla `scheduled_activities`
--
ALTER TABLE `scheduled_activities`
  ADD CONSTRAINT `scheduled_activities_ibfk_1` FOREIGN KEY (`id_activity`) REFERENCES `activities` (`id_activity`),
  ADD CONSTRAINT `scheduled_activities_ibfk_2` FOREIGN KEY (`id_shift`) REFERENCES `shifts` (`id_shift`);

--
-- Filtros para la tabla `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `shifts_ibfk_1` FOREIGN KEY (`id_institution`) REFERENCES `institutions` (`id_institution`);

--
-- Filtros para la tabla `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_ibfk_1` FOREIGN KEY (`id_scheduled_activity`) REFERENCES `scheduled_activities` (`id_scheduled_activity`),
  ADD CONSTRAINT `subscriptions_ibfk_2` FOREIGN KEY (`id_person`) REFERENCES `people` (`id_person`);

--
-- Filtros para la tabla `user_institutions`
--
ALTER TABLE `user_institutions`
  ADD CONSTRAINT `user_institutions_ibfk_1` FOREIGN KEY (`id_institution`) REFERENCES `institutions` (`id_institution`),
  ADD CONSTRAINT `user_institutions_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`),
  ADD CONSTRAINT `user_institutions_ibfk_3` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
