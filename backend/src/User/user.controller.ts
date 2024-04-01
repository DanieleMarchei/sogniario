import { Controller, Get, StreamableFile, Response } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";
import { Public } from "src/Auth/auth.decorator";

@Crud({
  model: {
    type: User,
  },
  query: {
    join: {
      dreams: {},
      psqis: {},
      chronotypes: {},
    },
  },
})
@ApiTags("User")
@ApiSecurity("bearer")
@Controller("user")
export class UserController implements CrudController<User> {
  constructor(public service: UserService) {}

  @Public()
  @Get("/download")
  async downloadDreams(@Response({ passthrough: true }) res) {
    res.set({
      "Content-Type": "application/zip",
      "Content-Disposition": 'attachment; filename="dreamsdump.zip"',
    });
    return new StreamableFile(await this.service.downloadDreams(1));
  }
}
