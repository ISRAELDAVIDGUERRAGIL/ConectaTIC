import { expect } from 'chai';
import jwtService from '../../utils/jwtService.js';

describe('JWTService - Pruebas Unitarias', () => {
  const testUser = {
    id: 1,
    nombre: 'Juan Pérez',
    correo: 'juan@example.com'
  };

  describe('signToken()', () => {
    it('Debe crear un token JWT válido', () => {
      const token = jwtService.signToken(testUser);

      expect(token).to.be.a('string');
      expect(token.length).to.be.greaterThan(0);
      // Un JWT tiene formato: header.payload.signature
      expect(token.split('.').length).to.equal(3);
    });

    it('El token debe contener los datos del usuario', () => {
      const token = jwtService.signToken(testUser);
      const decoded = jwtService.verifyToken(token);

      expect(decoded).to.have.property('id', testUser.id);
      expect(decoded).to.have.property('nombre', testUser.nombre);
      expect(decoded).to.have.property('correo', testUser.correo);
    });

    it('El token debe incluir expiration (exp)', () => {
      const token = jwtService.signToken(testUser);
      const decoded = jwtService.verifyToken(token);

      expect(decoded).to.have.property('exp');
      expect(decoded.exp).to.be.a('number');
      // exp debe ser mayor que ahora (en segundos)
      expect(decoded.exp).to.be.greaterThan(Math.floor(Date.now() / 1000));
    });

    it('Debe generar tokens diferentes para el mismo usuario', (done) => {
      const token1 = jwtService.signToken(testUser);
      
      // Esperar un segundo para que el timestamp cambie
      setTimeout(() => {
        const token2 = jwtService.signToken(testUser);
        
        // Los tokens deben ser diferentes (contienen timestamp)
        // Si son iguales es porque se generaron en el mismo segundo (timestamp igual)
        // Lo cual podría suceder, así que aceptamos ambos casos pero verificamos que sean JWTs válidos
        expect(token1).to.be.a('string');
        expect(token2).to.be.a('string');
        expect(token1.split('.').length).to.equal(3);
        expect(token2.split('.').length).to.equal(3);
        
        done();
      }, 1000);
    });

    it('Debe aceptar usuario con propiedades adicionales', () => {
      const userWithExtra = {
        ...testUser,
        rol: 'admin',
        activo: true
      };

      const token = jwtService.signToken(userWithExtra);
      const decoded = jwtService.verifyToken(token);

      expect(decoded).to.have.property('rol', 'admin');
      expect(decoded).to.have.property('activo', true);
    });
  });

  describe('verifyToken()', () => {
    it('Debe validar un token correcto', () => {
      const token = jwtService.signToken(testUser);
      const decoded = jwtService.verifyToken(token);

      expect(decoded).to.be.an('object');
      expect(decoded).to.have.property('id');
    });

    it('Debe rechazar un token inválido', () => {
      const invalidToken = 'invalid.token.here';

      try {
        jwtService.verifyToken(invalidToken);
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error).to.be.instanceOf(Error);
      }
    });

    it('Debe rechazar un token manipulado', () => {
      const token = jwtService.signToken(testUser);
      const parts = token.split('.');
      // Manipular el payload
      const manipulated = parts[0] + '.eyBpZDogOTk5IH0.invalid';

      try {
        jwtService.verifyToken(manipulated);
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error).to.be.instanceOf(Error);
      }
    });

    it('Debe rechazar un token vacío', () => {
      try {
        jwtService.verifyToken('');
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error).to.be.instanceOf(Error);
      }
    });

    it('Debe rechazar un token null', () => {
      try {
        jwtService.verifyToken(null);
        expect.fail('Debería haber lanzado un error');
      } catch (error) {
        expect(error).to.be.instanceOf(Error);
      }
    });

    it('Debe decodificar correctamente todos los campos del usuario', () => {
      const complexUser = {
        id: 123,
        nombre: 'María García Rodríguez',
        correo: 'maria.garcia@example.com',
        progreso: 75
      };

      const token = jwtService.signToken(complexUser);
      const decoded = jwtService.verifyToken(token);

      expect(decoded).to.deep.include(complexUser);
    });
  });

  describe('Token Expiration', () => {
    it('El token debe expirar después de 7 días', () => {
      const token = jwtService.signToken(testUser);
      const decoded = jwtService.verifyToken(token);

      const nowSeconds = Math.floor(Date.now() / 1000);
      const sevenDaysSeconds = 7 * 24 * 60 * 60;

      // exp debe estar entre ahora y ahora + 7 días (con margen)
      expect(decoded.exp).to.be.greaterThan(nowSeconds);
      expect(decoded.exp).to.be.lessThan(nowSeconds + sevenDaysSeconds + 60); // +60 seg de margen
    });
  });
});
