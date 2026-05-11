import zipfile
import io
from typing import Any
from http.client import HTTPMessage
from router import Router
from pathlib import Path

class UploadRouter(Router):
  def __init__(self, prefix: str = '/upload'):
    base_path = Path(__file__).parent
    file_path = base_path / "views"

    super().__init__(prefix, str(file_path))
    self._register_routes()

  def _register_routes(self):
    @self.get('')
    def upload_form(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      return self.render_template('upload.html', prefix=self.prefix)

    @self.post('')
    def handle_upload(query_params: dict[str, list[str]], body: Any, headers: HTTPMessage):
      if not isinstance(body, bytes):
        return {"error": "Invalid upload"}

      content_type = headers.get('Content-Type', '')
      if 'multipart/form-data' not in content_type:
        return {"error": "Expected multipart/form-data"}

      boundary = content_type.split('boundary=')[1].encode()
      parts = body.split(b'--' + boundary)

      for part in parts:
        if b'filename=' in part and b'.zip' in part:
          header_end = part.find(b'\r\n\r\n')
          if header_end != -1:
            file_data = part[header_end + 4:]
            if file_data.endswith(b'\r\n'):
              file_data = file_data[:-2]

            zip_buffer = io.BytesIO(file_data)

            try:
              with zipfile.ZipFile(zip_buffer, 'r') as zf:
                file_list = zf.namelist()

                contents = {}
                for name in file_list:
                  if not name.endswith('/'):
                    with zf.open(name) as f:
                      data = f.read()
                      try:
                        contents[name] = data.decode('utf-8')[:500]
                      except UnicodeDecodeError:
                        contents[name] = f"<binary file, {len(data)} bytes>"

                return {
                  "status": "success",
                  "files": file_list,
                  "preview": contents
                }
            except zipfile.BadZipFile:
              return {"error": "Invalid ZIP file"}

      return {"error": "No ZIP file found in upload"}
