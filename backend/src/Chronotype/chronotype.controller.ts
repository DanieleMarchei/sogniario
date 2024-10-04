import { Controller, UnauthorizedException } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { ChronotypeService } from "./chronotype.service";
import { Chronotype } from "src/entities/chronotype.entity";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { CreateType, ProtectAlter, ProtectCreate, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { UserType } from "src/entities/user_type.enum";
import { AuthUser } from "src/Auth/auth.decorator";
import { User } from "src/entities/user.entity";

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
    let data = await this.base.getManyBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let dataToCheck : Chronotype[] = data["data"] !== undefined ? data["data"] : data;

    for(let i = 0; i < dataToCheck.length; i++){
      let element = dataToCheck[i];
      let targetUser : User = undefined;

      if (element.user !== undefined){
        targetUser = element.user;
      }else{
        let res = await this.service.findOne({
          where: {
            id: element.id,
          },
          relations: ["user"]
        });
        if(res === null){
          throw new UnauthorizedException();
        }
        targetUser = res.user;
      }

      if (userType == UserType.USER){
        if (targetUser.id !== user.sub) throw new UnauthorizedException();
      }

      if (userType == UserType.RESEARCHER){
        if (targetUser.organization.id !== user.organization) throw new UnauthorizedException();
      }
    }

    return data;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<Chronotype> {
    let data = await this.base.getOneBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let targetUser : User = undefined;

    if (data.user !== undefined){
      targetUser = data.user;
    }else{
      let res = await this.service.findOne({
        where: {
          id: data.id,
        },
        relations: ["user"]
      });
      targetUser = res.user;
    }

    if (userType == UserType.USER){
      if (targetUser.id !== user.sub) throw new UnauthorizedException();
    }

    if (userType == UserType.RESEARCHER){
      if (targetUser.organization.id !== user.organization) throw new UnauthorizedException();
    }

    return data;
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
