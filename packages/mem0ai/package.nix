{
  lib,
  buildPythonPackage,
  fetchPypi,
  # dependencies
  qdrant-client,
  pydantic,
  openai,
  posthog,
  pytz,
  sqlalchemy,
  protobuf ? protobuf5,
  protobuf5,
  # optional: graph (without langchain-neo4j/memgraph - requires separate packaging)
  neo4j,
  rank-bm25,
  kuzu,
  # optional: vector_stores
  chromadb,
  weaviate-client,
  pymongo,
  elasticsearch,
  psycopg,
  psycopg-pool,
  redis,
  faiss,
  # optional: llms
  anthropic,
  litellm,
  groq,
  ollama,
  google-generativeai,
  google-genai,
  # optional: extras
  boto3,
  sentence-transformers,
  fastembed,
  langchain-community,
  opensearch-py,
}:

buildPythonPackage (finalAttrs: {
  pname = "mem0ai";
  version = "1.0.3";
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-9QDD3swSwmY7KtgprE7c0MZ08r2b9Kv39cBSKu89PPg=";
  };

  dependencies = [
    qdrant-client
    pydantic
    openai
    posthog
    pytz
    sqlalchemy
    protobuf
  ];

  optional-dependencies = {
    # Graph memory (entity/relationship tracking)
    # NOTE: Full graph memory requires langchain-neo4j/langchain-memgraph (not in nixpkgs)
    # These packages enable basic neo4j connectivity but not mem0's MemoryGraph class
    graph = [
      neo4j
      rank-bm25
      kuzu
      # langchain-neo4j: not in nixpkgs (required for mem0 graph memory)
      # langchain-memgraph: not in nixpkgs
    ];
    vector_stores = [
      chromadb
      weaviate-client
      pymongo
      elasticsearch
      psycopg
      psycopg-pool
      redis
      faiss
      # pinecone: not in nixpkgs
      # redisvl: not in nixpkgs
    ];
    llms = [
      anthropic
      litellm
      # openai is in core dependencies
      groq
      ollama
      google-generativeai
      google-genai
      # together: not in nixpkgs
      # vertexai: not in nixpkgs
    ];
    extras = [
      boto3
      sentence-transformers
      fastembed
      langchain-community
      opensearch-py
    ];
  };

  # mem0 tries to create ~/.mem0 directory on import
  env.HOME = "$(mktemp -d)";
  pythonImportsCheck = [ "mem0" ];
  doCheck = false;

  meta = {
    description = "Long-term memory for AI Agents";
    homepage = "https://github.com/mem0ai/mem0";
    license = lib.licenses.asl20;
  };
})
