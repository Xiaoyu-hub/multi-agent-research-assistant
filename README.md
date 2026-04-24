# Multi-Agent Research Assistant

> 基于多 Agent 协作的 AI 研究助手，支持 RAG 检索、搜索与报告生成

## 功能特性

- **5 个专业化 Agent 协同工作**
  - Planner: 任务分解与规划
  - Search × 3: 论文搜索、行业搜索、技术搜索
  - RAG: 知识库检索
  - Writer: 报告生成与整合
  - Critic: 质量审核与审批

- **混合检索能力**
  - 向量检索 (Chroma/Qdrant) + 关键词检索 (BM25)
  - Rerank 重排序
  - 搜索工具降级 (API → MCP 浏览器)

- **完整工程化**
  - FastAPI RESTful API
  - 多环境配置管理 (default/production)
  - 错误处理与重试机制
  - 四层 Memory 管理

## 技术栈

- **LLM**: OpenCode Zen (MiniMax M2.5 Free/Pro)
- **Agent Framework**: 自定义 Agent 架构
- **RAG**: Chroma/Qdrant + BM25
- **Search**: Serper/Baidu/DuckDuckGo + MCP Browser
- **API**: FastAPI + Uvicorn
- **Memory**: Redis / Session / Agent

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/Xiaoyu-hub/multi-agent-research-assistant.git
cd multi-agent-research-assistant
```

### 2. 创建虚拟环境

```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows
```

### 3. 安装依赖

```bash
pip install -r requirements.txt
```

### 4. 配置环境变量

```bash
cp .env.example .env
# 编辑 .env，填入 API Key
```

必需的环境变量：
- `OPENCODE_API_KEY`: OpenCode Zen API Key
- `SERPER_API_KEY`: Serper 搜索 API Key (可选)
- `REDIS_URL`: Redis 连接 URL (可选)

### 5. 启动服务

```bash
# 方式1: 使用 init.sh
./init.sh

# 方式2: 手动启动
python -m uvicorn src.app:app --host 0.0.0.0 --port 8000 --reload
```

### 6. 访问服务

- API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## 使用示例

###创建查询任务

```bash
curl -X POST http://localhost:8000/api/v1/query \
  -H "Content-Type: application/json" \
  -d '{"query": "调研2024年AI Agent的进展"}'
```

### 查询任务状态

```bash
curl -X GET http://localhost:8000/api/v1/tasks/{task_id}
```

## 项目结构

```
multi-agent-research-assistant/
├── ARCHITECTURE.md       # 完整架构文档
├── CLAUDE.md            # Agent 工作流说明
├── configs/
│   ├── default.yaml    # 开发配置
│   └── production.yaml
├── src/
│   ├── agents/        # 5 Agent 实现
│   │   ├── planner.py
│   │   ├── search.py
│   │   ├── rag.py
│   │   ├── writer.py
│   │   └── critic.py
│   ├── tools/         # 工具
│   │   ├── search.py
│   │   └── retriever.py
│   ├── memory/        # 内存管理
│   ├── config.py     # 配置加载
│   └── app.py       # FastAPI 应用
├── tests/            # 单元测试
└── knowledge/       # RAG 知识库
```

## 配置说明

### 开发环境 (default.yaml)

- LLM: MiniMax M2.5 Free
- Search: 自动选择
- RAG: Chroma (内存)
- Debug: true

### 生产环境 (production.yaml)

- LLM: MiniMax M2.5 Pro
- Search: Serper
- RAG: Qdrant
- Debug: false
- Workers: 4

## 测试

```bash
# 运行所有测试
pytest tests/ -v

# 运行特定测试
pytest tests/test_agents.py -v
pytest tests/test_tools.py -v

# 并行运行
pytest tests/ -n auto
```

## 文档

- [ARCHITECTURE.md](./ARCHITECTURE.md) - 完整架构文档
- [CLAUDE.md](./CLAUDE.md) - Agent 工作流说明

## License

MIT