# CSCE 765 Homework 1 - Built and Threat-Model an AI Agent

This repository contains evidence, analysis, and components used for the tasks listed in CSCE 765 Homework 1. 

## Description

This assignment covers four tasks:

1. Setting up the lab environment
2. Creating a harmless local tool and web lab
3. Direct and indirect prompt-injection experiment
4. Creating a threat-model and analyzing one advisory

## Dependencies

* Ubuntu 24.04 LTS x86-64
	* At least 4 vCPUs
	* At least 8GB RAM
	* Private NAT address
* Node 24.18.0
* NPM 11.16.0
* OpenClaw 2026.7.1-2
* Model protected.gpt-4o

## Completing Tasks

### Commands needed to complete tasks

Verify the architecture and network
```
uname -m		#expected: x86_64 
ip -brief address
ip route
```

Install base OS packages
```
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y curl git
sudo reboot
```

Install Node 24 LTS and OpenClaw
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source "$HOME/.nvm/nvm.sh"
nvm install 24.18.0
nvm alias default 24.18.0
node --version
npm --version
npm install -g openclaw@2026.7.1-2
openclaw --version
```

After setting up TAMUS API, run the following
``` 
export TAMU_API_KEY="<your key>"
node tamu-shim.mjs
openclaw onboard --non-interactive --accept-risk \--auth-choice custom-api-key --custom-provider-id tamus \--custom-compatibility
openai \--custom-base-url "http://127.0.0.1:8899/openai" \--custom-api-key via-shim \--custom-model-id "protected.gpt-4o" --skip-
channels
openclaw config set models.providers.tamus.request.allowPrivateNetwork true
openclaw config set agents.defaults.timeoutSeconds 600
openclaw config set agents.defaults.memorySearch.enabled false
openclaw config validate
openclaw models set tamus/protected.gpt-4o
openclaw daemon install && openclaw daemon start
```

Verify OpenClaw
```
openclaw gateway status # Runtime: running
openclaw doctor # no blocking errors
openclaw exec-policy show 	#note the effective policy
openclaw infer model run --model tamus/protected.gpt-4o \
--prompt "Reply with exactly: agent-ready"
```

Send a message to the agent
```
openclaw agent --agent main -m "your request here"
```

View tool usage
```
openclaw audit
```

Create needed directories
```
mkdir -p ~/csce765-agentsec/hw1/{bin,web,markers,evidence}
```

Create skill in
```
~/.openclaw/workspace/skills/safe-marker/SKILL.md
```

Create skill using
```
openclaw skills workshop propose-create \
  --name name_of_skill \
  --description "insert description" \
  --goal "insert goal" \
  --evidence "insert evidence" \
  --proposal path_to_proposal
```

Check name of skill with
```
openclaw skills workshop list
```

Inspect skill with
```
openclaw skills workshop inspect skill_name
```

Apply skill with
```
openclaw skills workshop apply skill_name
```

Check status of skill
```
openclaw skills check
```

After creating web pages, serve them with
```
cd ~/csce765-agentsec/hw1
python3 -m http.server 8000 --directory web --bind 127.0.0.1
```

## Checkoff
Check that the following are present in report.pdf before submitting
1. 3-5 benign task results
2. Task 3 trial write-ups, annotated transcript of each trial, <= 600 word answers to four questions
3. Task 4 data-flow diagram, needed labels, 500-700 word advisory analysis
4. Screenshots showing tasks running
5. Experience working on tasks
