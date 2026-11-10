# Deploy and Host AnythingLLM on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/anythingllm-server?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=anythingllm-server)

AnythingLLM is an all-in-one AI app: upload documents, pick any LLM, and chat with your files in workspaces, with agents, a built-in vector database and a developer API. This template runs AnythingLLM 1.19.0 on Railway, password-protected from the first boot, with your settings and data on a volume.

This is a community template, not made or supported by Mintplex Labs or the AnythingLLM project.

## About Hosting AnythingLLM

A stock AnythingLLM container has two traps on a public host. It starts with no password, so anyone who finds the address can use your instance and your LLM keys. And it saves what you set in the UI (provider, API keys, the password) to a file inside the container, which a redeploy resets. This template closes both.

**Sign in:** open your Railway domain and enter `ADMIN_PASSWORD`, which the template generates. Find it in the service's **Variables** tab. To change it, use **Settings > Security** in the app. The variable is read on the first boot only, so editing it later does nothing.

**Pick a model:** AnythingLLM ships with no LLM connected. In the setup screen or under **Settings > LLM** choose a provider (OpenAI, Anthropic, Gemini, OpenRouter, Groq, an Ollama server of your own and many more) and paste its key. Your choice is saved on the volume and survives redeploys.

**Your data:** documents, the SQLite database, the LanceDB vector store, the embedding model and the settings file all live on the volume at `/app/server/storage`.

## Common Use Cases

- A private "chat with my documents" workspace for PDFs, text files and web pages
- A shared knowledge base for a small team, with multi-user mode and per-workspace access
- A backend for your own tools through the developer API and embeddable chat widget

## Dependencies for AnythingLLM Hosting

- An API key for the LLM provider you choose. Nothing else: the vector database and the embedding model are built in.

### Deployment Dependencies

- [AnythingLLM on GitHub](https://github.com/Mintplex-Labs/anything-llm)
- [AnythingLLM documentation](https://docs.anythingllm.com)
- [Template source](https://github.com/two-workspaces/anythingllm)

### Implementation Details

- **Tested on Railway:** sign-in with the generated password, a wrong password and requests without a session refused, an LLM provider saved in the app, a password change, and all of these plus workspaces surviving redeploys. Uploading a text file and embedding it with the built-in embedder worked under 1 GB and 0.5 GB memory limits. Chatting with a real LLM provider was not tested.
- **Memory:** the service idles at about 400 MB. That fits a 0.5 GB plan for small documents, but with little room: for large PDFs, many documents or agents, use a plan with 1 GB or more.
- **First embed:** the built-in embedding model (about 25 MB) downloads to the volume the first time you embed a document, so the first one takes longer.
- **Secrets:** the keys that encrypt stored credentials and sign sessions (`SIG_KEY`, `SIG_SALT`, `JWT_SECRET`) are generated on the first boot and kept in `/app/server/storage/.env` on the volume. Deleting the volume means re-entering your provider keys.
- **Multi-user mode:** turn it on under **Settings > Security**. It replaces the single password with user accounts and cannot be turned off again.
- **Telemetry:** `DISABLE_TELEMETRY=true` is set, so the app sends no anonymous usage data to its makers. Remove the variable to opt in.
- **Backups:** turn on volume backups in the service's **Backups** tab.
- **Image:** upstream's `mintplexlabs/anythingllm:1.19.0`, pinned, plus a small boot script that fixes volume ownership, keeps the settings file on the volume and sets the first password.

## Why Deploy AnythingLLM on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying AnythingLLM on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
