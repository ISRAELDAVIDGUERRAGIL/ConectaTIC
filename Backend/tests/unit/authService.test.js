import { expect } from 'chai';
import sinon from 'sinon';
import authService from '../../services/authService.js';
import usuario from '../../models/usuario.js';

describe('AuthService - Pruebas Unitarias', () => {
  let findByEmailStub, createStub, comparePasswordStub, hashPasswordStub;

  beforeEach(() => {
    // Reset stubs antes de cada prueba
    findByEmailStub = sinon.stub(usuario, 'findByEmail');
    createStub = sinon.stub(usuario, 'create');
  });

  afterEach(() => {
    // Restore original functions después de cada prueba
    sinon.restore();
  });

  describe('registerUser()', () => {
    it('Debe registrar un usuario con datos válidos', async () => {
      const userData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'password123'
      };

      findByEmailStub.resolves(null); // Email no existe
      createStub.resolves({ id: 1, ...userData, password: 'hashed' });

      const result = await authService.registerUser(userData);

      expect(result).to.have.property('id');
      expect(result).to.have.property('nombre', 'Juan Pérez');
      expect(result).to.have.property('correo', 'juan@example.com');
      expect(findByEmailStub.calledOnce).to.be.true;
      expect(createStub.calledOnce).to.be.true;
    });

    it('Debe rechazar si el email ya existe', async () => {
      const userData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'password123'
      };

      findByEmailStub.resolves({ id: 1, correo: 'juan@example.com' }); // Email existe

      try {
        await authService.registerUser(userData);
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error.message).to.include('ya está registrado');
      }
    });

    it('Debe hashear la contraseña correctamente', async () => {
      const userData = {
        nombre: 'Juan Pérez',
        correo: 'juan@example.com',
        password: 'password123'
      };

      findByEmailStub.resolves(null);
      createStub.resolves({ id: 1, ...userData });

      const result = await authService.registerUser(userData);

      // La contraseña no debe ser igual al original (debe estar hasheada)
      expect(result.password).to.not.equal('password123');
    });

    it('Debe aceptar datos válidos con nombre largo', async () => {
      const userData = {
        nombre: 'María del Carmen Rodríguez García',
        correo: 'maria@example.com',
        password: 'secure123'
      };

      findByEmailStub.resolves(null);
      createStub.resolves({ id: 2, ...userData });

      const result = await authService.registerUser(userData);
      expect(result).to.have.property('nombre', userData.nombre);
    });
  });

  describe('loginUser()', () => {
    it('Debe rechazar login con email no registrado', async () => {
      const credentials = {
        correo: 'noexiste@example.com',
        password: 'password123'
      };

      findByEmailStub.resolves(null);

      try {
        await authService.loginUser(credentials);
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error.message).to.include('Credenciales inválidas');
      }
    });
  });
});
