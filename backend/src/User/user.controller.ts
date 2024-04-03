import {
  Controller,
  Get,
  StreamableFile,
  Response,
  Post,
  Body,
} from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";
import { Public } from "src/Auth/auth.decorator";
import { DownloadDto } from "./DTO/download.dto";

@Crud({
  model: {
    type: User,
  },
  query: {
    join: {
      dreams: {},
      psqis: {},
      chronotypes: {},
      organization: {eager:true}
    },
  },
})
@ApiTags("User")
@ApiSecurity("bearer")
@Controller("user")
export class UserController implements CrudController<User> {
  constructor(public service: UserService) {}

  @Public()
  @Post("/download")
  async downloadDreams(
    @Body() downloadDTO: DownloadDto,
    @Response({ passthrough: true }) res
  ) {
    res.set({
      "Content-Type": "application/zip",
      "Content-Disposition": 'attachment; filename="dreamsdump.zip"',
    });
    return new StreamableFile(
      await this.service.downloadDreams(downloadDTO.organizationId)
    );
  }
}
