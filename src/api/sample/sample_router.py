"""ルーターサンプル"""

import logging

from fastapi import APIRouter

logger = logging.getLogger(__name__)
router = APIRouter(
    prefix="/{version}/sample",
    tags=["Sample"],
)


@router.get("")
async def read_sample(version: str) -> dict:
    """_summary_

    Returns:
        _type_: _description_
    """
    logger.info("read_sample %s", version)
    return {"msg": "Hello World"}
