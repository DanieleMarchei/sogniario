import { Controller, UnauthorizedException } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { OrganizationService } from "./organization.service";
import { Organization } from "src/entities/organization.entity";
import { UserType } from "src/entities/user_type.enum";
import { Roles } from "src/Auth/roles.decorator";
import { AuthUser } from "src/Auth/auth.decorator";
@Crud({
  model: {
    type: Organization,
  },
  query: {
    join: {
      users: {},
      researchers: {},
    },
  },
})
@ApiTags("Organization")
@ApiSecurity("bearer")
@Controller("Organization")
export class OrganizationController implements CrudController<Organization> {
  constructor(public service: OrganizationService) {}

  get base(): CrudController<Organization> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN)
  async getMany(@ParsedRequest() req: CrudRequest): Promise<GetManyDefaultResponse<Organization> | Organization[]> {
    return this.base.getManyBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<Organization> {
    if(user.type === UserType.RESEARCHER){
      
      let requestedId = req.parsed.paramsFilter[0].value;
      if(user.organization !== requestedId){
        throw new UnauthorizedException();
      }
      
    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Organization): Promise<Organization> {
      return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Organization>): Promise<Organization[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Organization): Promise<Organization> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Organization): Promise<Organization> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Organization> {
    return this.base.deleteOneBase(req);
  }
}
