import { applyDecorators, Controller, UnauthorizedException, UseGuards } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudAuth, CrudController, CrudRequest, CrudRequestInterceptor, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { DreamService } from "./dream.service";
import { Dream } from "src/entities/dream.entity";
import { Roles, ProtectCreate, CreateType, ProtectDelete, ProtectAlter } from "src/Auth/roles.decorator";
import { UserType } from "src/entities/user_type.enum";
import { JwtService } from "@nestjs/jwt";
import { AuthUser } from "src/Auth/auth.decorator";
import { UserService } from "src/User/user.service";
import { protectByRole } from "src/Auth/roles.util";

@Crud({
  model: {
    type: Dream,
  }
})
@ApiTags("Dream")
@ApiSecurity("bearer")
@Controller("dream")
export class DreamController implements CrudController<Dream> {
  constructor(public service: DreamService) {}

  get base(): CrudController<Dream> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user: any): Promise<GetManyDefaultResponse<Dream> | Dream[]> {

    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Dream");
        let usePagination = this.service.decidePagination(req.parsed, req.options);

        if (usePagination){
          const data = await q.execute();
          const total = await q.getCount();
          const limit = q.expressionMap.take;
          const offset = q.expressionMap.skip;
    
          return this.service.createPageInfo(data, total, limit || total, offset || 0);

        }
        
        return await q.execute();

    }


    return this.base.getManyBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user: any): Promise<Dream> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Dream");
        return await q.execute();

    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Dream>): Promise<Dream[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Dream): Promise<Dream> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Dream> {
    return this.base.deleteOneBase(req);
  }
}
