import { Coords, Size, Scroll } from 'src/types';
import { CoordsUtils, SizeUtils } from 'src/utils';
import { PROJECTED_TILE_SIZE } from 'src/config';
import {
  getConnectorDirectionIcon,
  getConnectorRenderTiles,
  getGridSubset,
  isWithinBounds,
  screenToIso
} from '../renderer';

const getRendererSize = (tileSize: Size, zoom: number = 1): Size => {
  const projectedTileSize = SizeUtils.multiply(PROJECTED_TILE_SIZE, zoom);

  return {
    width: projectedTileSize.width * tileSize.width,
    height: projectedTileSize.height * tileSize.height
  };
};

const getScroll = (coords: Coords): Scroll => {
  return {
    position: coords,
    offset: CoordsUtils.zero()
  };
};

describe('Tests renderer utils', () => {
  test('getGridSubset() works correctly', () => {
    const gridSubset = getGridSubset([
      { x: 5, y: 5 },
      { x: 7, y: 7 }
    ]);

    expect(gridSubset).toEqual([
      { x: 5, y: 5 },
      { x: 5, y: 6 },
      { x: 5, y: 7 },
      { x: 6, y: 5 },
      { x: 6, y: 6 },
      { x: 6, y: 7 },
      { x: 7, y: 5 },
      { x: 7, y: 6 },
      { x: 7, y: 7 }
    ]);
  });

  test('isWithinBounds() works correctly', () => {
    const bounds: Coords[] = [
      { x: 4, y: 4 },
      { x: 6, y: 6 }
    ];

    const withinBounds = isWithinBounds({ x: 5, y: 5 }, bounds);
    const onBorder = isWithinBounds({ x: 4, y: 4 }, bounds);
    const outsideBounds = isWithinBounds({ x: 3, y: 3 }, bounds);

    expect(withinBounds).toBe(true);
    expect(onBorder).toBe(true);
    expect(outsideBounds).toBe(false);
  });

  test('screenToIso() works correctly when mouse is at center of project', () => {
    const zoom = 1;
    const rendererSize = getRendererSize({ width: 10, height: 10 }, zoom);
    const scroll = getScroll({ x: 0, y: 0 });
    const tile = screenToIso({
      mouse: {
        x: rendererSize.width / 2,
        y: rendererSize.height / 2
      },
      zoom,
      scroll,
      rendererSize
    });

    expect(tile).toEqual({ x: 0, y: -0 });
  });

  test('screenToIso() works correctly when mouse is at topLeft corner of project', () => {
    const zoom = 1;
    const rendererSize = getRendererSize({ width: 10, height: 10 }, zoom);
    const scroll = getScroll({ x: 0, y: 0 });
    const tile = screenToIso({
      mouse: {
        x: 0,
        y: 0
      },
      zoom,
      scroll,
      rendererSize
    });

    expect(tile).toEqual({ x: 0, y: 10 });
  });

  test('screenToIso() works correctly when mouse is at topLeft corner of project and zoom is 0.5', () => {
    const zoom = 0.5;
    const rendererSize = getRendererSize({ width: 10, height: 10 }, zoom);
    const scroll = getScroll({ x: 0, y: 0 });
    const tile = screenToIso({
      mouse: {
        x: 0,
        y: 0
      },
      zoom,
      scroll,
      rendererSize
    });

    expect(tile).toEqual({ x: 0, y: 10 });
  });

  test('screenToIso() works correctly when mouse is at center of project and zoom is 0.5 and screen is halfway scrolled', () => {
    const zoom = 1;
    const rendererSize = getRendererSize({ width: 10, height: 10 }, zoom);
    const scroll = getScroll({
      x: rendererSize.width / 2,
      y: rendererSize.height / 2
    });
    const tile = screenToIso({
      mouse: {
        x: rendererSize.width / 2,
        y: rendererSize.height / 2
      },
      zoom,
      scroll,
      rendererSize
    });

    expect(tile).toEqual({ x: 0, y: 10 });
  });

  test('getConnectorRenderTiles() mirrors local x positions into render space', () => {
    const tiles: Coords[] = [
      { x: 0, y: 0 },
      { x: 2, y: 1 },
      { x: 6, y: 4 }
    ];

    const renderTiles = getConnectorRenderTiles({
      tiles,
      rectangle: {
        from: { x: 10, y: 8 },
        to: { x: 4, y: 2 }
      }
    });

    expect(renderTiles).toEqual([
      { x: 6, y: 0 },
      { x: 4, y: 1 },
      { x: 0, y: 4 }
    ]);
  });

  test('getConnectorRenderTiles() keeps y coordinates unchanged', () => {
    const renderTiles = getConnectorRenderTiles({
      tiles: [
        { x: 1, y: 3 },
        { x: 2, y: 5 }
      ],
      rectangle: {
        from: { x: 5, y: 9 },
        to: { x: 1, y: 4 }
      }
    });

    expect(renderTiles.map((tile) => tile.y)).toEqual([3, 5]);
  });

  test('getConnectorDirectionIcon() returns 90° for rightward segment', () => {
    const directionIcon = getConnectorDirectionIcon([
      { x: 1, y: 1 },
      { x: 2, y: 1 }
    ]);

    expect(directionIcon?.rotation).toBe(90);
  });

  test('getConnectorDirectionIcon() returns 180° for downward segment', () => {
    const directionIcon = getConnectorDirectionIcon([
      { x: 3, y: 3 },
      { x: 3, y: 4 }
    ]);

    expect(directionIcon?.rotation).toBe(180);
  });

  test('getConnectorDirectionIcon() returns 45° for up-right diagonal segment', () => {
    const directionIcon = getConnectorDirectionIcon([
      { x: 1, y: 2 },
      { x: 2, y: 1 }
    ]);

    expect(directionIcon?.rotation).toBe(45);
  });

  test('connector render tile mapping keeps direction icon aligned with rendered path', () => {
    const renderTiles = getConnectorRenderTiles({
      tiles: [
        { x: 0, y: 1 },
        { x: 4, y: 1 }
      ],
      rectangle: {
        from: { x: 10, y: 5 },
        to: { x: 6, y: 1 }
      }
    });

    const directionIcon = getConnectorDirectionIcon(renderTiles);

    expect(directionIcon?.rotation).toBe(-90);
  });

  test('getConnectorDirectionIcon() falls back to -90° when the last segment has zero length', () => {
    const directionIcon = getConnectorDirectionIcon([
      { x: 5, y: 5 },
      { x: 5, y: 5 }
    ]);

    expect(directionIcon?.rotation).toBe(-90);
  });
});
