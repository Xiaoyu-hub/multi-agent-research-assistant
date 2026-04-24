# Multi-Agent Research Assistant - Project Instructions

## Project Context

A multi-agent AI research assistant system with 5 specialized agents:
- **Planner**: Task decomposition and planning
- **Search** × 3: Paper search, Industry search, Tech search
- **RAG**: Knowledge base retrieval
- **Writer**: Report generation
- **Critic**: Quality review and approval

Powered by FastAPI at http://localhost:8000

---

## MANDATORY: Agent Workflow

Every new agent session MUST follow this workflow:

### Step 1: Initialize Environment

```bash
./init.sh
```

This will:
- Install Python dependencies (if needed)
- Start the FastAPI server at http://localhost:8000
- Verify MCP tools availability

**DO NOT skip this step.** Ensure the server is running before proceeding.

### Step 2: Check Configuration

```bash
# Verify environment variables
cat .env
# Should contain: OPENCODE_API_KEY, etc.
```

### Step 3: Select Next Task

Read `task.json` and select ONE task to work on.

Selection criteria (in order of priority):
1. Choose a task where `passes: false`
2. Consider dependencies - fundamental features should be done first
3. Pick the highest-priority incomplete task

### Step 4: Implement the Task

- Read the task description and steps carefully
- Implement the functionality to satisfy all steps
- Follow existing code patterns and conventions in ARCHITECTURE.md

### Step 5: Test Thoroughly

After implementation, verify ALL steps in the task:

**Testing Requirements:**
1. **API changes**:
   - Test API endpoints with curl
   - Check FastAPI docs at http://localhost:8000/docs

2. **Agent logic changes**:
   - Run the agent with sample input
   - Verify output format matches spec

3. **All modifications must pass**:
   - `python -m py_compile src/**/*.py` - syntax check
   - pytest tests/ - unit tests
   - curl test against running API

### Step 6: Update Progress

Write your work to `progress.txt`:

```
## [Date] - Task: [task description]

### What was done:
- [specific changes made]

### Testing:
- [how it was tested]

### Notes:
- [any relevant notes for future agents]
```

### Step 7: Commit Changes (包含 task.json 更新)

**IMPORTANT: 所有更改必须在同一个 commit 中提交，包括 task.json 的更新！**

流程：
1. 更新 `task.json`，将任务的 `passes` 从 `false` 改为 `true`
2. 更新 `progress.txt` 记录工作内容
3. 一次性提交所有更改：

```bash
git add .
git commit -m "[task description] - completed"
```

**规则:**
- 只有在所有步骤都验证通过后才标记 `passes: true`
- 永远不要删除或修改任务描述
- 永远不要从列表中移除任务
- **一个 task 的所有内容（代码、progress.txt、task.json）必须在同一个 commit 中提交**

---

## ⚠️ 阻塞处理（Blocking Issues）

**如果任务无法完成测试或需要人工介入，必须遵循以下规则：**

### 需要停止任务并请求人工帮助的情况：

1. **缺少环境配置**：
   - .env 需要填写真实的 API 密钥（OPENCODE_API_KEY）
   - 需要配置搜索API（SERPER_API_KEY）
   - 需要配置Redis

2. **外部依赖不可用**：
   - LLM API 服务不可用
   - 搜索API服务不可用
   - 向量数据库连接失败

3. **测试无法进行**：
   - API服务启动失败
   - Agent逻辑测试需要真实LLM调用
   - RAG需要向量数据库

### 阻塞时的正确操作：

**DO NOT（禁止）：**
- ❌ 提交 git commit
- ❌ 将 task.json 的 passes 设为 true
- ❌ 假装任务已完成

**DO（必须）：**
- ✅ 在 progress.txt 中记录当前进度和阻塞原因
- ✅ 输出清晰的阻塞信息，说明需要人工做什么
- ✅ 停止任务，等待人工介入

### 阻塞信息格式：

```
🚫 任务阻塞 - 需要人工介入

**当前任务**: [任务名称]

**已完成的工作**:
- [已完成的代码/配置]

**阻塞原因**:
- [具体说明为什么无法继续]

**需要人工帮助**:
1. [具体的步骤 1]
2. [具体的步骤 2]
...

**解除阻塞后**:
- 运行 [命令] 继续任务
```

---

## Project Structure

```
/
├── ARCHITECTURE.md      # Full architecture documentation (source of truth)
├── CLAUDE.md          # This file - workflow instructions
├── task.json          # Task definitions
├── progress.txt      # Progress log
├── init.sh           # Initialization script
├── configs/
│   ├── default.yaml  # Development configuration
│   └── production.yaml
├── src/
│   ├── agents/      # 5 Agent implementations
│   ├── tools/      # Search & RAG tools
│   ├── memory/     # Memory management
│   ├── config.py   # Configuration loader
│   └── app.py      # FastAPI application
├── tests/           # Unit tests
└── knowledge/       # RAG knowledge base
```

## Commands

```bash
# Start server
./init.sh

# Or manually:
python -m uvicorn src.app:app --reload --port 8000

# Test API
curl http://localhost:8000/api/v1/health

# View API docs
# http://localhost:8000/docs

# Run tests
pytest tests/ -v

# Lint
ruff check src/
```

## Coding Conventions

- Python type hints required
- Pydantic for data validation
- Follow ARCHITECTURE.md for agent patterns
- Write tests for new features
- Use mock for LLM calls in tests

---

## Key Rules

1. **One task per session** - Focus on completing one task well
2. **Test before marking complete** - All steps must pass
3. **API testing for endpoint changes** - 必须用curl测试
4. **Document in progress.txt** - Help future agents understand your work
5. **One commit per task** - 所有更改必须在同一个 commit 中提交
6. **Never remove tasks** - Only flip `passes: false` to `true`
7. **Stop if blocked** - 需要人工介入时，不要提交，输出阻塞信息并停止