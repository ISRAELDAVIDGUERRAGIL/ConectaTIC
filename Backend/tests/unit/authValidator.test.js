import { expect } from 'chai';
import authValidator from '../../validators/authValidator.js';

describe('AuthValidator - Pruebas Unitarias', () => {
  describe('validateRegister()', () => {
    it('Debe aceptar datos de registro válidos', () => {
      const validData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(validData);
      expect(result).to.be.an('object');
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar email sin @', () => {
      const invalidData = {
        nombre: 'Juan Pérez',
        correo: 'juanexample.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(invalidData);
      expect(result.isValid).to.be.false;
      expect(result.errors).to.be.an('array');
      expect(result.errors.length).to.be.greaterThan(0);
    });

    it('Debe rechazar contraseña menor a 8 caracteres sin requisitos', () => {
      const invalidData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'pass'
      };

      const result = authValidator.validateRegister(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar contraseña válida (8+ chars con mayúscula, minúscula, dígito y especial)', () => {
      const validData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar nombre menor a 2 caracteres', () => {
      const invalidData = {
        nombre: 'J',
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar nombre de exactamente 2 caracteres', () => {
      const validData = {
        nombre: 'Jo',
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar nombre mayor a 100 caracteres', () => {
      const invalidData = {
        nombre: 'a'.repeat(101),
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar nombre de 100 caracteres', () => {
      const validData = {
        nombre: 'a'.repeat(100),
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateRegister(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar si faltan campos requeridos', () => {
      const incompleteData = {
        nombre: 'Juan Pérez'
      };

      const result = authValidator.validateRegister(incompleteData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar email con múltiples formatos válidos', () => {
      const validEmails = [
        'user@domain.com',
        'user.name@domain.com',
        'user_name@domain.org'
      ];

      validEmails.forEach(email => {
        const data = {
          nombre: 'Juan Pérez',
          correo: email,
          password: 'SecurePass123!'
        };
        const result = authValidator.validateRegister(data);
        expect(result.isValid).to.be.true;
      });
    });
  });

  describe('validateLogin()', () => {
    it('Debe aceptar credenciales válidas', () => {
      const validData = {
        correo: 'juan@example.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateLogin(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar email inválido en login', () => {
      const invalidData = {
        correo: 'juanexample.com',
        password: 'SecurePass123!'
      };

      const result = authValidator.validateLogin(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe rechazar contraseña vacía en login', () => {
      const invalidData = {
        correo: 'juan@example.com',
        password: ''
      };

      const result = authValidator.validateLogin(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe rechazar si faltan campos', () => {
      const incompleteData = {
        correo: 'juan@example.com'
      };

      const result = authValidator.validateLogin(incompleteData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar contraseña válida larga en login', () => {
      const validData = {
        correo: 'juan@example.com',
        password: 'SecurePass123!' + 'a'.repeat(86)
      };

      const result = authValidator.validateLogin(validData);
      expect(result.isValid).to.be.true;
    });
  });

  describe('validateUpdateUser()', () => {
    it('Debe aceptar actualización de nombre válida', () => {
      const validData = {
        nombre: 'Juan Carlos'
      };

      const result = authValidator.validateUpdateUser(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe aceptar actualización de email válida', () => {
      const validData = {
        correo: 'juannew@example.com'
      };

      const result = authValidator.validateUpdateUser(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe aceptar actualización combinada', () => {
      const validData = {
        nombre: 'Juan Carlos',
        correo: 'juannew@example.com'
      };

      const result = authValidator.validateUpdateUser(validData);
      expect(result.isValid).to.be.true;
    });

    it('Debe rechazar nombre inválido en actualización', () => {
      const invalidData = {
        nombre: 'J'
      };

      const result = authValidator.validateUpdateUser(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe rechazar email inválido en actualización', () => {
      const invalidData = {
        correo: 'invalid-email'
      };

      const result = authValidator.validateUpdateUser(invalidData);
      expect(result.isValid).to.be.false;
    });

    it('Debe aceptar objeto vacío (sin cambios)', () => {
      const emptyData = {};

      const result = authValidator.validateUpdateUser(emptyData);
      expect(result.isValid).to.be.true;
    });
  });
});
