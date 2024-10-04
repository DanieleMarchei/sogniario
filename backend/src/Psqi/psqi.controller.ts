import { Controller, UnauthorizedException } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, Override, ParsedBody, ParsedRequest, GetManyDefaultResponse } from "@nestjsx/crud";
import { PsqiService } from "./psqi.service";
import { Psqi } from "src/entities/psqi.entity";
import { UserType } from "src/entities/user_type.enum";
import { CreateType, ProtectAlter, ProtectCreate, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { AuthUser } from "src/Auth/auth.decorator";
import { User } from "src/entities/user.entity";

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
    let data = await this.base.getManyBase(req);
    let userType = user.type;

    if (userType == UserType.ADMIN) return data;
    
    let dataToCheck : Psqi[] = data["data"] !== undefined ? data["data"] : data;

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
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<Psqi> {
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

    return data;
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
