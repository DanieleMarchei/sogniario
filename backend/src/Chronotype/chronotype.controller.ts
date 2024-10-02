import { Controller, UnauthorizedException } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { ChronotypeService } from "./chronotype.service";
import { Chronotype } from "src/entities/chronotype.entity";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { CreateType, ProtectAlter, ProtectCreate, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { UserType } from "src/entities/user_type.enum";
import { AuthUser } from "src/Auth/auth.decorator";
import { protectByRole } from "src/Auth/roles.util";

@Crud({
  model: {
    type: Chronotype,
  },
})
@ApiTags("Chronotype")
@ApiSecurity("bearer")
@Controller("chronotype")
export class ChronotypeController implements CrudController<Chronotype> {
  constructor(public service: ChronotypeService) {}

  get base(): CrudController<Chronotype> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<GetManyDefaultResponse<Chronotype> | Chronotype[]> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Chronotype");
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
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<Chronotype> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "Chronotype");
        let result = await q.execute();
        if(result.length !== 1){
          throw new UnauthorizedException();
        }

        return result[0];

    }

    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Chronotype): Promise<Chronotype> {
      return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectCreate(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Chronotype>): Promise<Chronotype[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Chronotype): Promise<Chronotype> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectAlter()
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Chronotype): Promise<Chronotype> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Chronotype> {
    return this.base.deleteOneBase(req);
  }
}
