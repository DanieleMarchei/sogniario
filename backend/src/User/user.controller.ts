import { Controller } from "@nestjs/common";
import { ApiTags } from "@nestjs/swagger";
import { Crud, CrudController } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";

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
@Controller("user")
export class UserController implements CrudController<User> {
  constructor(public service: UserService) {}
}
