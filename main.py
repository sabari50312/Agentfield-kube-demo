from agentfield import Agent, AIConfig
from reasoners import reasoners_router
import os
from dotenv import load_dotenv
load_dotenv()

# Basic agent setup - works immediately
app = Agent(
    node_id="my-agent",
    agentfield_server="http://localhost:8080",
    version="1.0.0",
    dev_mode=True,
    ai_config=AIConfig(
        model="openai/gpt-4o",  # LiteLLM format: provider/model
        temperature=0.7,
    ),
)

# Include reasoners from separate file
app.include_router(reasoners_router)

if __name__ == "__main__":
    # Auto-discover available port starting from 8000
    app.serve(auto_port=True, dev=True, reload=False)