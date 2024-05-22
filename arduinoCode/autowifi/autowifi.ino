#include <WiFi.h>
#include <WebServer.h>

const char* ap_ssid = "auto";          // Cambia esto por el SSID de tu red ESP32
const char* ap_password = "12345678";  // Cambia esto por la contraseña de tu red ESP32

WebServer server(80);

String receivedSSID;
String receivedPassword;

void handleRoot() {
  if (server.hasArg("ssid") && server.hasArg("password")) {
    receivedSSID = server.arg("ssid");
    receivedPassword = server.arg("password");
    Serial.println("SSID recibido: " + receivedSSID);
    Serial.println("Password recibido: " + receivedPassword);
    server.send(200, "text/plain", "Datos recibidos correctamente");
    connectToNetwork(receivedSSID, receivedPassword);
  } else {
    server.send(400, "text/plain", "Faltan parámetros");
  }
}

void connectToNetwork(String ssid, String password) {
  Serial.println("Conectando a la red WiFi...");
  WiFi.begin(ssid.c_str(), password.c_str());

  int max_attempts = 10;
  int attempt = 0;
  while (WiFi.status() != WL_CONNECTED && attempt < max_attempts) {
    delay(1000);
    Serial.print(".");
    attempt++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("");
    Serial.println("Conectado a WiFi!");
    Serial.print("Dirección IP: ");
    Serial.println(WiFi.localIP());

    // Enviar la nueva IP al cliente
    server.on("/get_ip", HTTP_GET, []() {
      server.send(200, "text/plain", WiFi.localIP().toString());
    });

  } else {
    Serial.println("");
    Serial.println("No se pudo conectar a la red WiFi.");
  }
}

void handleMove() {
  if (server.hasArg("action")) {
    String action = server.arg("action");
    Serial.println("Acción recibida: " + action);

    if (action == "forward") {
      digitalWrite(2, HIGH);
      digitalWrite(13, HIGH);
      digitalWrite(14, LOW);
      digitalWrite(15, LOW);
    } else if (action == "backward") {
      digitalWrite(2, LOW);
      digitalWrite(13, LOW);
      digitalWrite(14, HIGH);
      digitalWrite(15, HIGH);

    } else if (action == "left") {
      digitalWrite(2, HIGH);
      digitalWrite(13, LOW);
      digitalWrite(14, LOW);
      digitalWrite(15, HIGH);
    } else if (action == "right") {
      digitalWrite(2, LOW);
      digitalWrite(13, HIGH);
      digitalWrite(14, HIGH);
      digitalWrite(15, LOW);
    } else if (action == "stop") {
      digitalWrite(2, LOW);
      digitalWrite(13, LOW);
      digitalWrite(14, LOW);
      digitalWrite(15, LOW);
    }

    server.send(200, "text/plain", "Acción ejecutada: " + action);
  } else {
    server.send(400, "text/plain", "Falta parámetro de acción");
  }
}

void setup() {
  Serial.begin(115200);
  WiFi.softAP(ap_ssid, ap_password);

  IPAddress IP = WiFi.softAPIP();
  Serial.print("Dirección IP del AP: ");
  Serial.println(IP);  // Debería imprimir 192.168.4.1

  // Configurar pines de control del motor como salidas
  pinMode(2, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(14, OUTPUT);
  pinMode(15, OUTPUT);

  // Asegurarse de que los motores estén apagados al inicio
  digitalWrite(2, LOW);
  digitalWrite(13, LOW);
  digitalWrite(14, LOW);
  digitalWrite(15, LOW);

  server.on("/", HTTP_POST, handleRoot);
  server.on("/move", HTTP_POST, handleMove);

  server.begin();
  Serial.println("Servidor iniciado");
}

void loop() {
  server.handleClient();
}
