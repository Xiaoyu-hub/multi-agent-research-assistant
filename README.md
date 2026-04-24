# Multi-Agent Research Assistant

> 基于 LangChain 的多 Agent 协作研究助手，支持 RAG 检索、任务规划与协同写作

## 功能

- 多个专业化 Agent 协同完成研究任务
- RAG 知识库检索 + 实时信息搜索
- 任务规划、结果整合、质量审核全链路
- 支持流式输出

## 技术栈

- LangChain (Agent 框架)
- OpenAI / Qwen (LLM)
- FAISS + bge-large-zh (RAG)
- DuckDuckGo Search (搜索)

## 快速开始

```bash
pip install -r requirements.txt
export OPENAI_API_KEY="sk-..."
python app.py
```