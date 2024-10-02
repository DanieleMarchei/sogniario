import { Controller, UnauthorizedException } from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { ResearcherService } from "./researcher.service";
import { Researcher } from "src/entities/researcher.entity";
import { UserType } from "src/entities/user_type.enum";
import { Roles } from "src/Auth/roles.decorator";
import { AuthUser } from "src/Auth/auth.decorator";

@Crud({
  model: {
    type: Researcher,
  },
  query: {
    join: {
      organization: { eager: true },
    },
  },
})
@ApiTags("Researcher")
@ApiSecurity("bearer")
@Controller("researcher")
export class ResearcherController implements CrudController<Researcher> {
  constructor(public service: ResearcherService) {}

  get base(): CrudController<Researcher> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN)
  async getMany(@ParsedRequest() req: CrudRequest): Promise<GetManyDefaultResponse<Researcher> | Researcher[]> {
    return this.base.getManyBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user: any): Promise<Researcher> {
    if(user.type === UserType.RESEARCHER){
      let requestedId = req.parsed.paramsFilter[0].value;

      let targetResearcher = await this.service.findOne({
        where: {
          id: requestedId,
          deleted: false
        }
      });
      
      if(targetResearcher === undefined){
        throw new UnauthorizedException();
      }

      if(targetResearcher.id !== user.sub){
        throw new UnauthorizedException();
      }
      
    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Researcher): Promise<Researcher> {
      return this.base.createOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<Researcher>): Promise<Researcher[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Researcher): Promise<Researcher> {
    return this.base.updateOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: Researcher): Promise<Researcher> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN)
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | Researcher> {
    return this.base.deleteOneBase(req);
  }
}
