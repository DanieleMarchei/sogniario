import { Controller } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, Override, ParsedBody, ParsedRequest, GetManyDefaultResponse } from "@nestjsx/crud";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";
import { UserType } from "src/entities/user_type.enum";
import { CreateType, ProtectAlter, ProtectCreate, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { AuthUser } from "src/Auth/auth.decorator";
import { protectByRole } from "src/Auth/roles.util";

@Crud({
  model: {
    type: Psqi,
  },
})
@ApiTags("Psqi")
@ApiSecurity("bearer")
@Controller("Psqi")
export class PsqiController implements CrudController<Psqi> {
  constructor(public service: PsqiService) {}

  get base(): CrudController<Psqi> {
    return this;
  }


  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<GetManyDefaultResponse<Psqi> | Psqi[]> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Psqi");
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
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<Psqi> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Psqi");
        return await q.execute();

    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Psqi): Promise<Psqi> {
      return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Psqi>): Promise<Psqi[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Psqi): Promise<Psqi> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Psqi): Promise<Psqi> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Psqi> {
    return this.base.deleteOneBase(req);
  }
}
