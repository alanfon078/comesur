// Archivo: backend/tests/api.test.js
const request = require('supertest');
// Importa tu aplicación express sin iniciar el servidor en un puerto
const app = require('../src/server'); 

describe('API Negocios - Pruebas de Integración (SEARCH)', () => {
  
  // Implementación de TC-API-002
  it('TC-API-002: Búsqueda con filtros devuelve resultados', async () => {
    const res = await request(app)
      .get('/api/negocios/filtrar?tipoComida=hamburguesa&presupuesto=100');
      
    expect(res.statusCode).toEqual(200);
    expect(res.body.success).toBe(true);
    expect(Array.isArray(res.body.data)).toBe(true);
    // Validar que el primer elemento contiene la estructura esperada
    if(res.body.data.length > 0) {
      expect(res.body.data[0]).toHaveProperty('platillo');
      expect(res.body.data[0]).toHaveProperty('precio');
      expect(parseFloat(res.body.data[0].precio)).toBeLessThanOrEqual(100);
    }
  });

  // Implementación de TC-API-004
  it('TC-API-004: Validación de parámetros inválidos (Presupuesto negativo)', async () => {
    const res = await request(app)
      .get('/api/negocios/filtrar?presupuesto=-50');
      
    expect(res.statusCode).toEqual(400);
    expect(res.body.success).toBe(false);
    expect(res.body.error).toBeDefined();
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
  });
});