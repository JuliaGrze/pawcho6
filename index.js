const http = require('http');
const PORT = process.env.PORT || 80;

const server = http.createServer((req, res) => {
  // Obsługa endpointu /health
  if (req.url === '/health') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('OK');
    return;
  }

  // Obsługa głównej strony
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end(`
    <html>
      <head><title>Informacje o systemie</title></head>
      <body>
        <h1>Informacje o systemie</h1>
        <p><strong>Adres IP:</strong> ${process.env.HOSTNAME}</p>
        <p><strong>Nazwa hosta:</strong> ${process.env.HOSTNAME}</p>
        <p><strong>Wersja aplikacji:</strong> ${process.env.VERSION || 'Brak wersji'}</p>
      </body>
    </html>
  `);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Serwer działa na porcie ${PORT}`);
});
