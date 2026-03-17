FROM python:3.13-slim

# Install system utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates bash && \
    rm -rf /var/lib/apt/lists/*

# Install uv (fast Python installer)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# uv installs to /root/.local/bin — hardcode the path (Docker doesn't expand $HOME in ENV)
ENV PATH="/root/.local/bin:${PATH}"

# Verify uv is on PATH
RUN uv --version

# Create a virtual environment
RUN uv venv --python 3.13 /opt/venv

# Activate the virtual environment for all subsequent steps
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:${PATH}"

# Install AgentField CLI — must use bash (the script uses bash-only syntax)
RUN curl -sSf https://agentfield.ai/get | bash

# The installer puts the af binary in /root/.agentfield/bin — hardcode (no $HOME in ENV)
ENV PATH="/root/.agentfield/bin:/root/.agentfield-staging/bin:${PATH}"

# Verify AgentField CLI is on PATH
RUN af --version

# Initialise a new AgentField project
RUN af init my-agent --defaults

# Set working directory to the agent project
WORKDIR /my-agent

# Install Python requirements
# COPY requirements.txt .
# RUN pip install -r requirements.txt
RUN uv pip install agentfield python-dotenv psycopg2-binary

COPY . .

# Expose the default AgentField control-plane port
EXPOSE 8080

# Start the control plane + run the agent
CMD ["sh", "-c", "af server & python main.py"]
