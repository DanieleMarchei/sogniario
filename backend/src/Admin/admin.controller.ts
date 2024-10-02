import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { AdminService } from "./admin.service";
import { Admin } from "src/entities/admin.entity";
import { UserType } from "src/entities/user_type.enum";
import { Roles } from "src/Auth/roles.decorator";

@Crud({
  model: {
    type: Admin,
  }
})
@ApiTags("Admin")
@ApiSecurity("bearer")
@Controller("admin")
export class AdminController implements CrudController<Admin> {
  constructor(public service: AdminService) {}

  get base(): CrudController<Admin> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN)
  async getMany(@ParsedRequest() req: CrudRequest): Promise<GetManyDefaultResponse<Admin> | Admin[]> {
    return this.base.getManyBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async getOne(@ParsedRequest() req: CrudRequest): Promise<Admin> {
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Admin): Promise<Admin> {
      return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Admin>): Promise<Admin[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Admin): Promise<Admin> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Admin): Promise<Admin> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Admin> {
    return this.base.deleteOneBase(req);
  }
}
