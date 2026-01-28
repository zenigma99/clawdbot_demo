# 🤖 Moltbot Setup - Agente AI Personale

**Moltbot è un agente AI completo che può:**
- 💬 Chattare su Telegram (e altri canali)
- 💻 Eseguire codice e script
- 📁 Creare, modificare e analizzare file
- 🌐 Navigare il web e fare ricerche
- 🔧 Automatizzare task ripetitivi
- 📊 Analizzare dati e creare report
- 🎨 Generare immagini
- ...e molto altro!

Non è un semplice chatbot: è un **assistente autonomo** che può eseguire azioni reali sul sistema.

## 📋 Requisiti

- Docker installato
- Un server Linux (o macOS)
- Un bot Telegram (da creare con @BotFather)
- API key OpenAI (o Anthropic)

---

## 🚀 Installazione Rapida (5 minuti)

### 1. Clona questa Repository

```bash
git clone <url-repo>
cd moltbot-setup
```

### 2. Crea le Directory

```bash
sudo mkdir -p data/{config,workspace,models}
sudo chown -R 1000:1000 data/
```

### 3. Crea il Bot Telegram

1. Apri Telegram e cerca **@BotFather**
2. Invia `/newbot`
3. Scegli un nome (es. "Il Mio Assistente")
4. Scegli un username (es. "mio_assistente_bot")
5. **Copia il token** che ti viene dato

### 4. Ottieni l'API Key OpenAI

1. Vai su https://platform.openai.com/api-keys
2. Crea una nuova API key
3. **Copia la key** (inizia con `sk-...`)

### 5. Configura le Credenziali

```bash
# Copia il template
cp .env.example .env

# Genera il token del gateway
openssl rand -hex 32

# Modifica il file .env
nano .env
```

Inserisci:
- Il token generato come `MOLTBOT_GATEWAY_TOKEN`
- Il bot token di Telegram
- La API key di OpenAI

### 6. Builda l'Immagine

```bash
chmod +x build-local.sh
./build-local.sh
```

**Tempo**: ~5-10 minuti al primo build.

### 7. Avvia il Bot

```bash
docker-compose up -d
```

### 8. Verifica i Logs

```bash
docker-compose logs -f moltbot-gateway
```

Dovresti vedere:
```
✓ Gateway listening on 0.0.0.0:18789
✓ Telegram bot connected
```

### 9. Prova il Bot

1. Cerca il tuo bot su Telegram
2. Premi **START**
3. Invia un messaggio: `Ciao!`
4. Il bot ti darà un **codice di pairing**
5. Sul server, esegui:
   ```bash
   docker-compose exec moltbot-gateway node dist/index.js pairing approve telegram <CODICE>
   ```
6. Invia di nuovo `Ciao!`
7. **Il bot dovrebbe rispondere!** 🎉

---

## 🎯 Cosa Può Fare Moltbot

Moltbot non è un semplice chatbot: è un **agente autonomo** con accesso a strumenti reali.

### 💻 Coding & Sviluppo
```
Tu: "Crea uno script Python che analizza questo CSV e genera un grafico"
Bot: [crea file.py, lo esegue, genera grafico.png]
```

### 📁 Gestione File
```
Tu: "Leggi tutti i PDF in questa cartella e fammi un riassunto"
Bot: [legge i file, analizza, crea summary.md]
```

### 🌐 Web & Ricerca
```
Tu: "Cerca le ultime notizie su AI e scrivimi un report"
Bot: [usa web search, analizza risultati, crea report.md]
```

### 🔧 Automazione
```
Tu: "Ogni mattina alle 9, controllami le email e fammi un riassunto"
Bot: [crea cron job, monitora, invia summary]
```

### 📊 Analisi Dati
```
Tu: "Analizza questo Excel e trovami le anomalie"
Bot: [legge Excel, analizza, genera insights + grafici]
```

### 🎨 Creatività
```
Tu: "Genera un'immagine di un robot che programma"
Bot: [chiama API immagini, genera, invia]
```

### 🤝 Multi-Agent
```
Tu: "Crea un sub-agent che mi monitora il server"
Bot: [spawna nuovo agent isolato, configura monitoring]
```

---

## 🔧 Comandi Utili

### Docker

```bash
# Avvia
docker-compose up -d

# Ferma
docker-compose down

# Riavvia
docker-compose restart moltbot-gateway

# Logs in tempo reale
docker-compose logs -f moltbot-gateway

# Rebuild immagine (dopo update del codice)
./build-local.sh
docker-compose up -d --force-recreate moltbot-gateway
```

### Bot

```bash
# Approva un utente (pairing)
docker-compose exec moltbot-gateway node dist/index.js pairing approve telegram <CODICE>

# Lista pairing in attesa
docker-compose exec moltbot-gateway node dist/index.js pairing list telegram

# Health check
docker-compose exec moltbot-gateway node dist/index.js health
```

### Comandi in Chat (Telegram)

Una volta accoppiato, puoi usare questi comandi direttamente in chat:

```
/status              # Stato della sessione
/new                 # Reset conversazione
/model openai/gpt-4o # Cambia modello
/think high          # Abilita reasoning dettagliato
/verbose on          # Debug mode
```

---

## ⚙️ Configurazione

### Cambiare Modello AI

Modifica `data/config/moltbot.json`:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai/gpt-4o"
      }
    }
  }
}
```

**Modelli disponibili**:
- `openai/gpt-4o` - Veloce, ottimo per uso generale
- `openai/gpt-4` - Più potente
- `openai/o1` - Reasoning avanzato (più lento)
- `anthropic/claude-opus-4-5` - Claude (richiede API key Anthropic)

### Timezone

Il bot è configurato per l'orario italiano (Europe/Rome). Per cambiarlo, modifica `moltbot.json`:

```json
{
  "agents": {
    "defaults": {
      "userTimezone": "Europe/Rome"
    }
  }
}
```

### Accesso Aperto (senza pairing)

⚠️ **Attenzione**: Permette a chiunque di usare il bot!

In `moltbot.json`:

```json
{
  "channels": {
    "telegram": {
      "dmPolicy": "open",
      "allowFrom": ["*"]
    }
  }
}
```

---

## 🐛 Troubleshooting

### Bot non risponde

```bash
# Verifica logs
docker-compose logs moltbot-gateway | grep -i telegram

# Dovresti vedere: "Telegram bot connected"
```

### "Webhook active" error

```bash
# Rimuovi webhook
docker-compose exec moltbot-gateway node dist/index.js telegram delete-webhook

# Riavvia
docker-compose restart moltbot-gateway
```

### Container non si avvia

```bash
# Verifica che l'immagine sia stata buildata
docker images | grep moltbot

# Se manca, rebuilda
./build-local.sh
```

### Permessi negati

```bash
sudo chown -R 1000:1000 data/
```

### Reset completo

```bash
# Ferma
docker-compose down

# Cancella dati (⚠️ perderai le conversazioni)
sudo rm -rf data/config/* data/workspace/*

# Ricrea directory
sudo mkdir -p data/{config,workspace,models}
sudo chown -R 1000:1000 data/

# Riavvia
docker-compose up -d
```

---

## 📁 Struttura Directory

```
moltbot-setup/
├── docker-compose.yml       # Configurazione Docker
├── moltbot.json            # Config del bot (copiato in data/config/)
├── .env.example            # Template credenziali
├── .env                    # ⚠️ Le TUE credenziali (NON committare!)
├── build-local.sh          # Script per buildare l'immagine
├── README.md               # Questa guida
└── data/                   # Dati persistenti (NON committare!)
    ├── config/             # Configurazione e sessioni
    ├── workspace/          # Workspace del bot
    └── models/             # (per Ollama, se usato)
```

---

## 🔒 Sicurezza

### ⚠️ IMPORTANTE

- **NON committare** il file `.env` su git (contiene le API keys!)
- **NON committare** la directory `data/` (contiene conversazioni private!)
- Il `.gitignore` è già configurato per proteggere questi file

### Token e API Keys

- `MOLTBOT_GATEWAY_TOKEN`: Password per accedere al gateway (genera con `openssl rand -hex 32`)
- `TELEGRAM_BOT_TOKEN`: Token del bot Telegram (da @BotFather)
- `OPENAI_API_KEY`: API key OpenAI (da platform.openai.com)

**Trattali come password!** Non condividerli mai.

---

## 💰 Costi

### OpenAI

- **GPT-4o**: ~$2.50 per 1M token input, ~$10 per 1M token output
- **Costo medio conversazione**: $0.01 - $0.05 per conversazione tipica
- **Stima mensile**: $5-20 per uso personale moderato

Monitora i costi su: https://platform.openai.com/usage

### Anthropic Claude (alternativa)

- **Claude Opus 4.5**: ~$15 per 1M token input, ~$75 per 1M token output
- Più costoso ma più capace per task complessi

---

## 🆘 Supporto

Se hai problemi:

1. Controlla i **logs**: `docker-compose logs -f`
2. Verifica la **configurazione**: `cat .env` (controlla che non ci siano errori di battitura)
3. Leggi la sezione **Troubleshooting** sopra
4. Contatta il team

---

## 📚 Risorse

- **Moltbot GitHub**: https://github.com/moltbot/moltbot
- **OpenAI API Docs**: https://platform.openai.com/docs
- **Telegram Bot API**: https://core.telegram.org/bots

---

## 🎯 Quick Reference

```bash
# Setup iniziale (una volta)
./build-local.sh
cp .env.example .env
nano .env
docker-compose up -d

# Uso quotidiano
docker-compose logs -f              # Vedi cosa sta succedendo
docker-compose restart              # Riavvia se si blocca
docker-compose exec moltbot-gateway node dist/index.js pairing approve telegram <CODE>

# Aggiornamenti
git pull                            # Aggiorna i file
./build-local.sh                    # Rebuilda l'immagine
docker-compose up -d --force-recreate
```

---

**Buon lavoro con Moltbot! 🚀**

_Per domande o problemi, contatta il team._
