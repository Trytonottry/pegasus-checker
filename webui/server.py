from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from pathlib import Path

app = FastAPI()

@app.get("/reports")
def list_reports():
    base = Path("reports")
    return [str(p) for p in base.iterdir() if p.is_dir()]

@app.get("/reports/{rid}")
def get_report(rid: str):
    folder = Path("reports") / rid
    files = [str(p) for p in folder.rglob("*")]
    return {"report": rid, "files": files}

app.mount("/", StaticFiles(directory="webui/frontend/dist", html=True))
