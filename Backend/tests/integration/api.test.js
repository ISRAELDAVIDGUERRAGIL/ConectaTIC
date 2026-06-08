import request from 'supertest';
import { expect } from 'chai';
import server from '../../server.js';

describe('API Endpoints - Pruebas de Integración', () => {
  let authToken;
  let userId;
  const testUser = {
    nombre: 'Test User',
    correo: `test${Date.now()}@example.com`,
    password: 'TestPass123@'
  };

  describe('Health Check', () => {
    it('Debe retornar status 200 en GET /api', (done) => {
      request(server)
        .get('/api')
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('message');
          expect(res.body).to.have.property('version');
          done();
        });
    });
  });

  describe('POST /api/auth/register', () => {
    it('Debe registrar un usuario exitosamente', (done) => {
      request(server)
        .post('/api/auth/register')
        .send(testUser)
        .expect(201)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.have.property('id');
          expect(res.body.data).to.have.property('nombre', testUser.nombre);
          expect(res.body.data).to.have.property('correo', testUser.correo);
          expect(res.body.data).to.not.have.property('password');
          userId = res.body.data.id;
          done();
        });
    });

    it('Debe rechazar registro con email duplicado', (done) => {
      request(server)
        .post('/api/auth/register')
        .send(testUser)
        .expect(400)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar registro con datos inválidos', (done) => {
      const invalidData = {
        nombre: 'A', // Muy corto
        correo: 'invalidemail', // Sin @
        password: 'short' // Muy corta
      };

      request(server)
        .post('/api/auth/register')
        .send(invalidData)
        .expect(400)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar si faltan campos requeridos', (done) => {
      const incompleteData = {
        nombre: 'Juan Pérez'
        // Faltan correo y password
      };

      request(server)
        .post('/api/auth/register')
        .send(incompleteData)
        .expect(400)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });

  describe('POST /api/auth/login', () => {
    it('Debe hacer login con credenciales correctas', (done) => {
      request(server)
        .post('/api/auth/login')
        .send({
          correo: testUser.correo,
          password: testUser.password
        })
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.have.property('token');
          expect(res.body.data).to.have.property('usuario');
          expect(res.body.data.usuario).to.have.property('id');
          expect(res.body.data.usuario).to.not.have.property('password');
          authToken = res.body.data.token;
          done();
        });
    });

    it('Debe rechazar login con contraseña incorrecta', (done) => {
      request(server)
        .post('/api/auth/login')
        .send({
          correo: testUser.correo,
          password: 'wrongpassword'
        })
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar login con email no registrado', (done) => {
      request(server)
        .post('/api/auth/login')
        .send({
          correo: 'noexiste@example.com',
          password: 'password123'
        })
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar login con datos inválidos', (done) => {
      request(server)
        .post('/api/auth/login')
        .send({
          correo: 'invalidemail', // Sin @
          password: 'pass'
        })
        .expect(400)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });

  describe('GET /api/usuarios', () => {
    it('Debe retornar lista de usuarios autenticado', (done) => {
      request(server)
        .get('/api/usuarios')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.be.an('array');
          expect(res.body.data.length).to.be.greaterThan(0);
          done();
        });
    });

    it('Debe rechazar acceso sin token', (done) => {
      request(server)
        .get('/api/usuarios')
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar acceso con token inválido', (done) => {
      request(server)
        .get('/api/usuarios')
        .set('Authorization', 'Bearer invalid.token.here')
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });

  describe('GET /api/usuarios/:id', () => {
    it('Debe obtener usuario por ID autenticado', (done) => {
      request(server)
        .get(`/api/usuarios/${userId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.have.property('id', userId);
          expect(res.body.data).to.have.property('nombre', testUser.nombre);
          done();
        });
    });

    it('Debe rechazar acceso sin token', (done) => {
      request(server)
        .get(`/api/usuarios/${userId}`)
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe retornar 404 para usuario no existente', (done) => {
      request(server)
        .get('/api/usuarios/99999')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });

  describe('PUT /api/usuarios/:id', () => {
    it('Debe actualizar usuario autenticado', (done) => {
      const updateData = {
        nombre: 'Test User Actualizado'
      };

      request(server)
        .put(`/api/usuarios/${userId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.have.property('nombre', updateData.nombre);
          done();
        });
    });

    it('Debe rechazar actualización sin token', (done) => {
      request(server)
        .put(`/api/usuarios/${userId}`)
        .send({ nombre: 'Otro nombre' })
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe rechazar actualización con datos inválidos', (done) => {
      const invalidData = {
        nombre: 'A' // Muy corto
      };

      request(server)
        .put(`/api/usuarios/${userId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidData)
        .expect(400)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });

  describe('PUT /api/usuarios/progreso', () => {
    it('Debe actualizar progreso del usuario', (done) => {
      request(server)
        .put('/api/usuarios/progreso')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ incremento: 10 })
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', true);
          expect(res.body.data).to.have.property('progreso');
          done();
        });
    });

    it('Debe rechazar actualización de progreso sin token', (done) => {
      request(server)
        .put('/api/usuarios/progreso')
        .send({ incremento: 10 })
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe limitar progreso máximo a 100', (done) => {
      request(server)
        .put('/api/usuarios/progreso')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ incremento: 1000 }) // Intenta incrementar mucho
        .expect(200)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body.data.progreso).to.equal(100);
          done();
        });
    });
  });

  describe('DELETE /api/usuarios/:id', () => {
    it('Debe rechazar eliminación sin token', (done) => {
      request(server)
        .delete(`/api/usuarios/${userId}`)
        .expect(401)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });

    it('Debe retornar 404 al intentar eliminar usuario no existente', (done) => {
      request(server)
        .delete('/api/usuarios/99999')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404)
        .end((err, res) => {
          if (err) return done(err);
          expect(res.body).to.have.property('success', false);
          done();
        });
    });
  });
});
