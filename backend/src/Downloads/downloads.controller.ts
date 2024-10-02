import { Controller, Get, Header, StreamableFile } from "@nestjs/common";
import { createReadStream, readFileSync } from "fs";
import { join } from "path";
import { Public } from "src/Auth/auth.decorator";

@Controller("file")
export class FileController {
  @Public()
  @Get("/apk")
  @Header("Content-Type", "application/vnd.android.package-archive")
  @Header("Content-Disposition", 'attachment; filename="sogniario.apk"')
  getFile(): StreamableFile {
    const file = createReadStream(join(process.cwd(), "/builds/sogniario.apk"));
    return new StreamableFile(file);
  }

  @Public()
  @Get("/version")
  @Header("Content-Type", "text/plain")
  getVersion(): String {
    const text = readFileSync(('builds/version.txt'), 'utf8');
    return text;
  }
}
