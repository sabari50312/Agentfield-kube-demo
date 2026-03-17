from agentfield import Agent, AIConfig
from dotenv import load_dotenv

from reasoners import reasoners_router

load_dotenv()

# Basic agent setup - works immediately
app = Agent(
    node_id="my-agent",
    agentfield_server="http://agentfield-control-plane:8080",
    callback_url="http://my-agent:8001",   
    version="1.0.0",
    dev_mode=True,
    ai_config=AIConfig(
        model="openai/gpt-4o",
        temperature=0.7,
    ),
)

# Include reasoners from separate file
app.include_router(reasoners_router)

if __name__ == "__main__":
    # Auto-discover available port starting from 8000
    app.serve(auto_port=True, dev=True, reload=False)
