FROM anasty17/mltb:latest

# Set workdir early
WORKDIR /usr/src/app

# Create virtual environment
RUN python3 -m venv /usr/src/app/mltbenv

# Copy requirement list first (better layer caching)
COPY requirements.txt .

# Install Python deps
RUN /usr/src/app/mltbenv/bin/pip install --no-cache-dir -r requirements.txt

# Copy rest of the project
COPY . .

# Install OS dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends sshpass openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Avoid giving 777 unless you absolutely need it
# If needed, target only necessary dirs
RUN chmod -R 755 /usr/src/app

# Launch script
CMD ["bash", "start.sh"]
